{- $Id: AFRPTestsAccum.hs,v 1.2 2003/11/10 21:28:58 antony Exp $
******************************************************************************
*                                  A F R P                                   *
*                                                                            *
*       Module:         AFRPTestsAccum					     *
*       Purpose:        Test cases for accumulators			     *
*	Authors:	Antony Courtney and Henrik Nilsson		     *
*                                                                            *
*             Copyright (c) Yale University, 2003                            *
*                                                                            *
******************************************************************************
-}

module AFRPTestsAccum (
    accum_tr,
    accum_trs,
    accum_st0,
    accum_st0r,
    accum_st1,
    accum_st1r
) where

import Maybe (fromJust)

import AFRP
import AFRPInternals (Event(NoEvent, Event))

import AFRPTestsCommon

------------------------------------------------------------------------------
-- Test cases for accumulators
------------------------------------------------------------------------------

accum_inp1 = (fromJust (head delta_inp), zip (repeat 1.0) (tail delta_inp))
    where
	delta_inp =
	    [Just NoEvent, Nothing, Just (Event (+1.0)), Just NoEvent,
	     Just (Event (+2.0)), Just NoEvent, Nothing, Nothing,
	     Just (Event (*3.0)), Just (Event (+5.0)), Nothing, Just NoEvent,
	     Just (Event (/2.0)), Just NoEvent, Nothing, Nothing]
            ++ repeat Nothing

accum_inp2 = (fromJust (head delta_inp), zip (repeat 1.0) (tail delta_inp))
    where
	delta_inp =
	    [Just (Event (+1.0)), Just NoEvent, Nothing, Nothing,
	     Just (Event (+2.0)), Just NoEvent, Nothing, Nothing,
	     Just (Event (*3.0)), Just (Event (+5.0)), Nothing, Just NoEvent,
	     Just (Event (/2.0)), Just NoEvent, Nothing, Nothing]
            ++ repeat Nothing

accum_inp3 = deltaEncode 1.0 $
    [NoEvent,   NoEvent,   Event 1.0, NoEvent,
     Event 2.0, NoEvent,   NoEvent,   NoEvent,
     Event 3.0, Event 5.0, Event 5.0, NoEvent,
     Event 0.0, NoEvent,   NoEvent,   NoEvent]
    ++ repeat NoEvent

accum_inp4 = deltaEncode 1.0 $
    [Event 1.0, NoEvent,   NoEvent,   NoEvent,
     Event 2.0, NoEvent,   NoEvent,   NoEvent,
     Event 3.0, Event 5.0, Event 5.0, NoEvent,
     Event 0.0, NoEvent,   NoEvent,   NoEvent]
    ++ repeat NoEvent


accum_t0 :: [Event Double]
accum_t0 = take 16 $ embed (accum 0.0) accum_inp1

accum_t0r =
    [NoEvent,   NoEvent,    Event 1.0,  NoEvent,
     Event 3.0, NoEvent,    NoEvent,    NoEvent,
     Event 9.0, Event 14.0, Event 19.0, NoEvent,
     Event 9.5, NoEvent,    NoEvent,    NoEvent]


accum_t1 :: [Event Double]
accum_t1 = take 16 $ embed (accum 0.0) accum_inp2

accum_t1r =
    [Event 1.0, NoEvent,    NoEvent,    NoEvent,
     Event 3.0, NoEvent,    NoEvent,    NoEvent,
     Event 9.0, Event 14.0, Event 19.0, NoEvent,
     Event 9.5, NoEvent,    NoEvent,    NoEvent]


accum_t2 :: [Event Int]
accum_t2 = take 16 $ embed (accumBy (\a d -> a + floor d) 0) accum_inp3

accum_t2r :: [Event Int]
accum_t2r =
    [NoEvent,  NoEvent,  Event 1,  NoEvent,
     Event 3,  NoEvent,  NoEvent,  NoEvent,
     Event 6,  Event 11, Event 16, NoEvent,
     Event 16, NoEvent,  NoEvent,  NoEvent]


accum_t3 :: [Event Int]
accum_t3 = take 16 $ embed (accumBy (\a d -> a + floor d) 0) accum_inp4

accum_t3r :: [Event Int]
accum_t3r =
    [Event 1,  NoEvent,  NoEvent,  NoEvent,
     Event 3,  NoEvent,  NoEvent,  NoEvent,
     Event 6,  Event 11, Event 16, NoEvent,
     Event 16, NoEvent,  NoEvent,  NoEvent]


accum_accFiltFun1 a d =
    let a' = a + floor d
    in
        if even a' then
	    (a', Just (a' > 10, a'))
        else
	    (a', Nothing)

accum_t4 :: [Event (Bool,Int)]
accum_t4 = take 16 $ embed (accumFilter accum_accFiltFun1 0) accum_inp3

accum_t4r :: [Event (Bool,Int)]
accum_t4r =
    [NoEvent,         NoEvent, NoEvent,         NoEvent,
     NoEvent,         NoEvent, NoEvent,         NoEvent,
     Event (False,6), NoEvent, Event (True,16), NoEvent,
     Event (True,16), NoEvent, NoEvent,         NoEvent]


accum_accFiltFun2 a d =
    let a' = a + floor d
    in
        if odd a' then
	    (a', Just (a' > 10, a'))
        else
	    (a', Nothing)

accum_t5 :: [Event (Bool,Int)]
accum_t5 = take 16 $ embed (accumFilter accum_accFiltFun2 0) accum_inp4

accum_t5r :: [Event (Bool,Int)]
accum_t5r =
    [Event (False,1), NoEvent,         NoEvent, NoEvent,
     Event (False,3), NoEvent,         NoEvent, NoEvent,
     NoEvent,         Event (True,11), NoEvent, NoEvent,
     NoEvent,         NoEvent,         NoEvent, NoEvent]


-- This can be seen as the definition of accumFilter
accumFilter2 :: (c -> a -> (c, Maybe b)) -> c -> SF (Event a) (Event b)
accumFilter2 f c_init =
    switch (never &&& attach c_init) afAux
    where
	afAux (c, a) =
            case f c a of
	        (c', Nothing) -> switch (never &&& (notYet>>>attach c')) afAux
	        (c', Just b)  -> switch (now b &&& (notYet>>>attach c')) afAux

	attach :: b -> SF (Event a) (Event (b, a))
        attach c = arr (fmap (\a -> (c, a)))

accum_t6 :: [Event (Bool,Int)]
accum_t6 = take 16 $ embed (accumFilter2 accum_accFiltFun1 0) accum_inp3

accum_t6r = accum_t4	-- Should agree!

accum_t7 :: [Event (Bool,Int)]
accum_t7 = take 16 $ embed (accumFilter2 accum_accFiltFun2 0) accum_inp4

accum_t7r = accum_t5	-- Should agree!


accum_trs =
    [ accum_t0 == accum_t0r,
      accum_t1 == accum_t1r,
      accum_t2 == accum_t2r,
      accum_t3 == accum_t3r,
      accum_t4 == accum_t4r,
      accum_t5 == accum_t5r,
      accum_t6 == accum_t6r,
      accum_t7 == accum_t7r
    ]

accum_tr = and accum_trs


accum_st0 :: Double
accum_st0 = testSFSpaceLeak 1000000
                            (repeatedly 1.0 1.0
                             >>> accumBy (+) 0.0
                             >>> hold (-99.99))

accum_st0r = 249999.0


accum_st1 :: Double
accum_st1 = testSFSpaceLeak 1000000
                            (arr dup
			     >>> first (repeatedly 1.0 1.0)
			     >>> arr (\(e,a) -> tag e a)
                             >>> accumFilter accumFun 0.0
                             >>> hold (-99.99))
    where
	accumFun c a | even (floor a) = (c+a, Just (c+a))
		     | otherwise      = (c, Nothing)

accum_st1r = 6.249975e10
