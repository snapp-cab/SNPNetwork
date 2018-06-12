//
//  RestError.swift
//  Driver
//
//  Created by Behdad Keynejad on 9/11/1396 AP.
//  Copyright © 1396 AP Snapp. All rights reserved.
//

import Foundation

public enum RestErrorCode: Int {
    case success = 200
    case badRequest = 400
    case unauthorized = 401
    case unknown = 1000
    case duplicateEmailAddress = 1001
    case passengerIsInRide = 1002
    case voucherIsNotValid = 1003
    case couldNotCalculateRidePrice = 1004
    case thisRideIsNotOfferedToThisDriver = 1005
    case rideNotFound = 1006
    case rideAcceptedBefore = 1007
    case acceptingStateError = 1008
    case arrivingStateError = 1009
    case boardingStateError = 1010
    case finishingStateError = 1011
    case cellphoneCodeNotValid = 1012
    case rideNotAcceptedYet = 1013
    case emailNotVerified = 1014
    case rideAlreadyRated = 1015
    case rideIsNotFinishedToRate = 1016
    case voucherCodeIsNotUsableForThisUserType = 1017
    case cantConnectToBank = 1018
    case ridePriceIsZero = 1019
    case rideCancellationError = 1020
    case invalidPassword = 1021
    case invalidDriverStatusCode = 1022 // driver valid statuses for updating is 1 (Available) and 2 (Busy)
    case phoneNumberNotVerified = 1028
    case smsVerificationLimitExceeded = 1030
    case emailNotRegisteredToResendVerification = 1031
    case emailIsAlreadyVerified = 1032
    case emailVerificationLimitExceeded = 1033
    case userIsBlocked = 1035
    case rideVoucherIsNotValid = 1037
    case cantTakeYourOwnRide = 1047
    
    case `default` = -1
    
    //    var message: String {
    //        return NSLocalizedString("REST error", comment: "Generic REST error")
    //    }
}
