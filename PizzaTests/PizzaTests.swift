//
//  PizzaTests.swift
//  PizzaTests
//
//  Created by Ioannis Diamantidis on 1/26/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import XCTest
@testable import Pizza

class PizzaTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let restaurants = """
            [
              {
                "id": 1,
                "name": "Pizza Heaven",
                "address1": "Kungsgatan 1",
                "address2": "111 43 Stockholm",
                "latitude": 59.336078,
                "longitude": 18.071807
              },
              {
                "id": 2,
                "name": "Pizzeria Apan",
                "address1": "Långholmsgatan 34",
                "address2": "117 33 Stockholm",
                "latitude": 59.315709,
                "longitude": 18.033507
              }
            ]
        """.data(using: .utf8)!

        let restaurant = try! JSONDecoder().decode([Restaurant].self, from: restaurants)
        print(restaurant)


        let menu = """
            [
              {
                "id": 1,
                "category": "Pizza",
                "name": "Vesuvius",
                "topping": [
                  "Tomat",
                  "Ost",
                  "Skinka"
                ],
                "price": 79,
                "rank": 3
              },
              {
                "id": 2,
                "category": "Pizza",
                "name": "Hawaii",
                "topping": [
                  "Tomat",
                  "Ost",
                  "Skinka",
                  "Ananas"
                ],
                "price": 79,
                "rank": 1
              },
              {
                "id": 3,
                "category": "Pizza",
                "name": "Parma",
                "topping": [
                  "Tomat",
                  "Ost",
                  "Parmaskinka",
                  "Oliver",
                  "Färska basilika"
                ],
                "price": 89,
                "rank": 2
              },
              {
                "id": 4,
                "category": "Dryck",
                "name": "Coca-cola, 33cl",
                "price": 10
              },
              {
                "id": 5,
                "category": "Dryck",
                "name": "Loka citron, 33cl",
                "price": 10
              },
              {
                "id": 6,
                "category": "Tillbehör",
                "name": "Pizzasallad",
                "price": 0
              },
              {
                "id": 7,
                "category": "Tillbehör",
                "name": "Bröd och smör",
                "price": 10
              }
            ]



        """.data(using: .utf8)!

        let menuDec = try! JSONDecoder().decode([MenuItem].self, from: menu)
        print(menuDec)


        let orderGet = """

            {
              "orderId": 1234412,
              "totalPrice": 168,
              "orderedAt": "2015-04-09T17:30:47.556Z",
              "esitmatedDelivery": "2015-04-09T17:45:47.556Z",
              "status": "ordered"
            }

        """.data(using: .utf8)!

        let orderPost = """
            {
              "cart": [
                {
                  "menuItemId": 2,
                  "quantity": 1
                },
                {
                  "menuItemId": 3,
                  "quantity": 1
                },
                {
                  "menuItemId": 6,
                  "quantity": 2
                }
              ],
              "restuarantId": 1
            }
        """.data(using: .utf8)!

        let orderDetails = """
            {
              "orderId": 1234412,
              "totalPrice": 168,
              "orderedAt": "2015-04-09T17:30:47.556Z",
              "esitmatedDelivery": "2015-04-09T17:50:47.556Z",
              "status": "baking",
              "cart": [
                {
                  "menuItemId": 2,
                  "quantity": 1
                },
                {
                  "menuItemId": 3,
                  "quantity": 1
                },
                {
                  "menuItemId": 6,
                  "quantity": 2
                }
              ],
              "restuarantId": 1
            }
        """.data(using: .utf8)!


        let orderGetDec = try! JSONDecoder().decode(OrderGet.self, from: orderGet)
        print(orderGetDec)

        let orderPostDec = try! JSONDecoder().decode(OrderPost.self, from: orderPost)
        print(orderPostDec)

        let orderDetailsDec = try! JSONDecoder().decode(OrderDetails.self, from: orderDetails)
        print(orderDetailsDec)


        let testOrderPost = OrderPost(cart: [CartItems(id: 1, quantity: 2)], restaurantId: 2)
        let jsonData = try! JSONEncoder().encode(testOrderPost)
        let jsonString = String(data: jsonData, encoding: .utf8)
        print(jsonString ?? "")


        let apiService = APIService()
        let url = URL(string: "http://www.stackoverflow.com")!
        apiService.get(from: url) { (result: APIService.Result<Restaurant>) in
            switch result {
            case .success(let data):
                print(data)
            case .error(let error):
                print(error)
            }
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
