//
//  MultipeerController.swift
//  Duel iOS App
//
//  Created by Jacob Kerames on 7/8/23.
//

import WatchConnectivity
import MultipeerConnectivity

class MultipeerController: NSObject, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, WCSessionDelegate, ObservableObject {

    // The Multipeer Connectivity Session
    private var session: MCSession
    
    // The Watch Connectivity Session
    private let wcSession: WCSession? = WCSession.isSupported() ? WCSession.default : nil

    // The Multipeer Connectivity Peer ID
    private var peerID: MCPeerID

    // The Multipeer Connectivity Service Advertiser
    private var serviceAdvertiser: MCNearbyServiceAdvertiser

    // The Multipeer Connectivity Service Browser
    private var serviceBrowser: MCNearbyServiceBrowser
    
    @Published var invitationReceived = false
    @Published var invitationFrom = ""

    override init() {
        // Initialize the Peer ID
        self.peerID = MCPeerID(displayName: UIDevice.current.name)

        // Initialize the Session
        self.session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: .required)

        // Initialize the Service Advertiser
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: self.peerID, discoveryInfo: nil, serviceType: "duel-game-0731")

        // Initialize the Service Browser
        self.serviceBrowser = MCNearbyServiceBrowser(peer: self.peerID, serviceType: "duel-game-0731")

        super.init()
        
        wcSession?.delegate = self
        wcSession?.activate()

        // Set the Session Delegate
        self.session.delegate = self

        // Set the Service Advertiser Delegate
        self.serviceAdvertiser.delegate = self
    }

    func startHosting() {
        // Start advertising peer
        self.serviceAdvertiser.startAdvertisingPeer()
    }

    func startJoining() {
        // Start browsing for peers
        self.serviceBrowser.startBrowsingForPeers()
    }

    // MARK: MCNearbyServiceAdvertiserDelegate Methods
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Extract the username from the context
        if let context = context, let discoveryInfo = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(context) as? [String: String], let username = discoveryInfo["username"] {
            print("Received invitation from \(username)")
            DispatchQueue.main.async {
                // Update the @Published properties:
                self.invitationFrom = username
                self.invitationReceived = true
            }
        } else {
            // Handle error: context is nil or cannot be unarchived
        }
    }

    // MARK: MCSessionDelegate Methods
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        // Handle peer state change
        switch state {
        case .connected:
            print("Connected to \(peerID.displayName)")
        case .connecting:
            print("Connecting to \(peerID.displayName)")
        case .notConnected:
            print("Not connected to \(peerID.displayName)")
        @unknown default:
            print("Unknown state received for peer: \(peerID.displayName)")
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // Handle received data
        print("Received data from \(peerID.displayName)")
        // TODO: Implement your logic to process received data
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // Handle stream receipt
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // Handle resource receipt
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // Handle resource completion
    }
    
    // MARK: WCSessionDelegate Methods
    func sessionDidBecomeInactive(_ session: WCSession) {
        <#code#>
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        <#code#>
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        <#code#>
    }
}
