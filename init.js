var initVoice = function() {
  if (annyang) {
    Shiny.onInputChange('jarvis', '');
    var commands = {
      'jarvis *jarvis': function(jarvis) {
        Shiny.onInputChange('jarvis', jarvis);
      }
    };
    annyang.addCommands(commands);
    annyang.start();
  }
};

$(function() {
  setTimeout(initVoice, 3);
});