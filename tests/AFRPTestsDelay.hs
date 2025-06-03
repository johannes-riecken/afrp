{- $Id: AFRPTestsDelay.hs,v 1.2 2003/11/10 21:28:58 antony Exp $
******************************************************************************
*                                  A F R P                                   *
*                                                                            *
*       Module:         AFRPTestsDelay                                       *
*       Purpose:        Test cases for delays                                *
*       Authors:        Antony Courtney and Henrik Nilsson                   *
*                                                                            *
*             Copyright (c) Yale University, 2003                            *
*                                                                            *
******************************************************************************
-}

module AFRPTestsDelay (delay_tr, delay_trs) where

import AFRP

import AFRPTestsCommon

------------------------------------------------------------------------------
-- Test cases for delays
------------------------------------------------------------------------------

delay_t0 = testSF1 (iPre 17)
delay_t0r =
    [17.0,0.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0,13.0,14.0,
     15.0,16.0,17.0,18.0,19.0,20.0,21.0,22.0,23.0]

delay_t1 = testSF2 (iPre 17)
delay_t1r =
    [17.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,1.0,1.0,2.0,2.0,2.0,2.0,2.0,
     3.0,3.0,3.0,3.0,3.0,4.0,4.0,4.0,4.0]

delay_trs =
    [ delay_t0 ~= delay_t0r,
      delay_t1 ~= delay_t1r
    ]

delay_tr = and delay_trs
