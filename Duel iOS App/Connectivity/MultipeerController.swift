//
//  MultipeerController.swift
//  Duel iOS App
//
//  Created by Jacob Kerames on 7/8/23.
//

import MultipeerConnectivity

class MultipeerController: NSObject, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate {

    // The Multipeer Connectivity Session
    private var session: MCSession
    
    // The Multipeer Connectivity Peer ID
    private var peerID: MCPeerID
    
    // The Multipeer Connectivity Service Advertiser
    private var serviceAdvertiser: MCNearbyServiceAdvertiser
    
    // The Multipeer Connectivity Service Browser
    private var serviceBrowser: MCNearbyServiceBrowser
    
    override init() {
        // Initialize the Peer ID
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        
        // Initialize the Session
        self.session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: .required)
        
        // Initialize the Service Advertiser
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: self.peerID, discoveryInfo: nil, serviceType: "duel-game")
        
        // Initialize the Service Browser
        self.serviceBrowser = MCNearbyServiceBrowser(peer: self.peerID, serviceType: "duel-game")
        
        super.init()
        
        // Set the Session Delegate
        self.session.delegate = self
        
        // Set the Service Advertiser Delegate
        self.serviceAdvertiser.delegate = self
        
        // Start Advertising
        self.serviceAdvertiser.startAdvertisingPeer()
        
        // Start Browsing
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    // MARK: MCNearbyServiceAdvertiserDelegate Methods
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Handle the receipt of an invitation
        invitationHandler(true, self.session)
    }
    
    // MARK: MCSessionDelegate Methods
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        // Handle peer session state changes
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // Handle receiving data
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // Handle receiving a stream
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // Handle starting to receive a resource
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // Handle finishing receiving a resource
    }
    
    // Implementation of Multipeer connectivity
    
    func startHosting() {
        // Code for starting hosting
    }
    
    func startJoining() {
        // Code for starting joining
    }
    
    // ...
}

