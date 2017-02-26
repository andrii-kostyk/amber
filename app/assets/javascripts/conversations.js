$(document).on('ready page:load', function() {
   if ( $("#conversation").length ) new Amber.Initialization();
});

var Amber = {};

Amber.Initialization = function() {
  var self = this;

  $.extend(this, new Amber.ElementaryProcessor());
  $.extend(this, new Amber.RecognitionProcessor(this));

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
  	  },
  	  function(response) {
        self.speak(response.message);
        self.performAction = self.pendingAppeal;
  	  }  
    );
  };

  this.pendingAppeal = function(text) {
    if (text.match(/Амбер/)) {
      self.speak("Wait a command");
      self.performAction = self.sendCommand;
    }
  }

  this.performAction = this.pendingAppeal;
  this.listen();
};

Amber.RecognitionProcessor = function(amber) {
  var self = this;
  var recognition = new webkitSpeechRecognition();

  recognition.continuous = true;
  recognition.interimResults = true;
  recognition.lang = "uk-UA";

  recognition.onresult = function(event) { 
    for (var i = event.resultIndex; i < event.results.length; ++i) {
      if (event.results[i].isFinal) amber.processRecognizedText(event.results[i][0].transcript);
    } 
  };
  
  recognition.onerror = function(e) {
    console.log("RecognitionProcessor error");
  }

  this.listen = function() {
  	recognition.start();
  };

  recognition.onend = function() {
  	amber.performAction = amber.pendingAppeal;
    recognition.start();
  };
};

Amber.ElementaryProcessor = function() {
  var utterance = new SpeechSynthesisUtterance();
  
  utterance.lang = 'en-US';
  utterance.onend = function () {};
  utterance.onerror = function (e) {};

  this.speak = function(text) {
    utterance.text = text;
    speechSynthesis.speak(utterance);
  };
};