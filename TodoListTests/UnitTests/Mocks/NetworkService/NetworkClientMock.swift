//
//  NetworkClientMock.swift
//  TodoListTests
//
//  Created by Yulya Greshnova on 17.07.2022.
//

@testable import TodoList
@testable import Core

class NetworkClientMock<T>: INetworkClient {
    var invokedSend = false
    var invokedSendCount = 0
    var invokedSendParameters: (requestData: NetworkRequestData<T>, Void)?
    var invokedSendParametersList = [(requestData: NetworkRequestData<T>, Void)]()

    func send<ResponseType>(requestData: NetworkRequestData<ResponseType>,
                            completion: @escaping(Result<ResponseType, Error>) -> Void) {
        invokedSend = true
        invokedSendCount += 1
        if let request = requestData as? NetworkRequestData<T> {
            invokedSendParameters = (request, ())
            invokedSendParametersList.append((request, ()))
        }
    }
}
