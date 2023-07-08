//
//  MultipeerController.swift
//  Duel iOS App
//
//  Created by Jacob Kerames on 7/8/23.
//

import MultipeerConnectivity

class MultipeerController: NSObject, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        <#code#>
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        <#code#>
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        <#code#>
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        <#code#>
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        <#code#>
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        <#code#>
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

