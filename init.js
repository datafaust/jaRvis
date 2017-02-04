var initVoice = function() {
  if (annyang) {
    Shiny.onInputChange('albert', '');
    var commands = {
      'albert *albert': function(albert) {
        Shiny.onInputChange('albert', albert);
      }
    };
    annyang.addCommands(commands);
    annyang.start();
  }
};

$(function() {
  setTimeout(initVoice, 3);
});