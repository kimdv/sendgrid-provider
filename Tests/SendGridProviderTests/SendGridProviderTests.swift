import XCTest
import SendGridProvider
import SMTP
@testable import Vapor

// Test inbox: https://www.mailinator.com/inbox2.jsp?public_to=vapor-sendgrid

class SendGridProviderTests: XCTestCase {
    static let allTests = [
        ("testDroplet", testDroplet),
        ("testSend", testSend),
    ]

    let apiKey = "SG.YOUR_KEY" // Set here, but don't commit to git!

    func testDroplet() throws {
        let config: Config = try [
            "droplet": [
                "mail": "sendgrid"
            ],
            "sendgrid": [
                "apiKey": apiKey
            ],
        ].makeNode(in: nil).converted()
        try config.addProvider(Provider.self)
        let drop = try Droplet(config)
        guard let _ = drop.mail as? SendGrid else {
            XCTFail("drop.mail is \(drop.mail)")
            return
        }
    }

    func testSend() throws {
        if apiKey == "SG.YOUR_KEY" {
            print("*** Not testing SendGrid as no API Key is set")
            return
        }
        let config: Config = try [
            "sendgrid": [
                "apiKey": apiKey
            ],
        ].makeNode(in: nil).converted()
        let sendgrid = try SendGrid(config: config)
        let email = Email(from: "vapor-sendgrid-from@mailinator.com",
                          to: "vapor-sendgrid@mailinator.com",
                          subject: "Email Subject",
                          body: "Hello Email")
        let attachment = EmailAttachment(filename: "dummy.data",
                                         contentType: "dummy/data",
                                         body: [1,2,3,4,5])
        email.attachments.append(attachment)
        try sendgrid.send(email)
    }

}
