#include "ofApp.h"


//--------------------------------------------------------------
void ofApp::setup(){	
    std::deque<int> deque_int;
    deque_int.push_back(1101111);
    deque_int.push_back(1100110);
    deque_int.push_back(1100110);
    
    int i = 0;
    BOOST_FOREACH( i, deque_int )
    {
        ofLog(OF_LOG_NOTICE, ofToString(i));
    }

    // These calls require the compiled Boost.Filesystem, Boost.System, and
    // Boost.Regex libraries. A successful link proves the XCFramework is used.
    const boost::filesystem::path path("/tmp/ofxiOSBoost/example.txt");
    const boost::regex expected("example\\.txt");
    const bool linked = boost::regex_match(path.filename().string(), expected);
    boostLinkStatus = linked ? "Boost XCFramework linked" : "Boost link test failed";
    ofLogNotice() << boostLinkStatus;
}

//--------------------------------------------------------------
void ofApp::update(){

}

//--------------------------------------------------------------
void ofApp::draw(){
	ofDrawBitmapStringHighlight(boostLinkStatus, 20, 40);
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}
