$(document).on('ready page:load', function() {
   if ( $("#conversation").length ) new Gray.Initialization();
});

var Gray = {};

Gray.Initialization = function() {
  var self = this;

  $.extend(this, new Gray.ElementaryProcessor());
  $.extend(this, new Gray.RecognitionProcessor(this));

  this.processRecognizedText = function(text) {
    self.performAction(text);
  };

  this.inprogress = function() {};

  this.sendCommand = function(text) {
    self.performAction = self.inprogress;
    Requests.sendCommand(text,
      function(response) {
        self.speak(response.message, true);
        self.performAction = self.pendingAppeal;
      },
      function(response) {
        self.speak(response.message, true);
        self.performAction = self.pendingAppeal;
      }  
    );
  };

  this.pendingAppeal = function(text) {
    if (text.match(/Грей/)) {
      self.speak('Так', false);
      self.performAction = self.sendCommand;
    }
  }

  this.performAction = this.pendingAppeal;
  this.listen();

  setTimeout(function(){
    window.location.reload(1);
  }, 60000);
  self.test_ua();
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
  var audio = document.getElementById("gray-speech"),
      reload = false;

  audio.onended = function() {
    if (reload) window.location.reload(1);
  };

  function google_tts(text) {
    var url = "http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=[_TTSTEXT_]&tl=Uk-ua"
    return url.replace('[_TTSTEXT_]', text)
  }

  this.speak = function(text, _reload) {
    reload = _reload;
    audio.src = google_tts(text);
    audio.play();
  };
};