$(document).on('ready page:load', function() {
   if ( $("#conversation").length ) new Gray.Initialization();
});

var Gray = {};

Gray.Initialization = function() {
  var self = this;

  $.extend(this, new Gray.ElementaryProcessor());
  $.extend(this, new Gray.RecognitionProcessor(this));

  this.processRecognizedText = function(text) {
  	console.log(text)
    self.performAction(text);
  };

  this.inprogress = function() {};

  this.sendCommand = function(text) {
  	self.performAction = self.inprogress;
  	Requests.sendCommand(text,
  	  function(response) {
  	  	self.speak(response.message);
        self.performAction = self.pendingAppeal;
        window.location.reload(1);
  	  },
  	  function(response) {
        self.speak(response.message);
        self.performAction = self.pendingAppeal;
        window.location.reload(1);
  	  }  
    );
  };

  this.pendingAppeal = function(text) {
    if (text.match(/Грей/)) {
      self.speak("Yes");
      self.performAction = self.sendCommand;
    }
  }

  this.performAction = this.pendingAppeal;
  this.listen();

  setTimeout(function(){
    self.speak("Reload");
    window.location.reload(1);
  }, 60000);
};

Gray.RecognitionProcessor = function(gray) {
  var self = this;
  var recognition = new webkitSpeechRecognition();

  recognition.continuous = true;
  recognition.interimResults = true;
  recognition.lang = "uk-UA";

  recognition.onresult = function(event) { 
    for (var i = event.resultIndex; i < event.results.length; ++i) {
      if (event.results[i].isFinal) gray.processRecognizedText(event.results[i][0].transcript);
    } 
  };
  
  recognition.onerror = function(e) {
    console.log("RecognitionProcessor error");
  }

  this.listen = function() {
  	recognition.start();
  };

  this.stopListen = function(){
    recognition.stop();
  };

  recognition.onend = function() {
  	gray.performAction = gray.pendingAppeal;
    recognition.start();
  };
};

Gray.ElementaryProcessor = function() {
  var utterance = new SpeechSynthesisUtterance();
  console.log("utterance", utterance)
  
  utterance.lang = 'en-US';
  utterance.onend = function () {
    console.log("speech end");
  };
  utterance.onerror = function (e) {
    console.log("speech eror", e);
  };

  this.speak = function(text) {
    utterance.text = text;
    speechSynthesis.speak(utterance);
  };
};