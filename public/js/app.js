var Ideas = function() {};

Ideas.prototype.login = function(options) {
    var that = this;
    
    $.ajax({
        url: options.url,
        type: 'POST',
        timeout: 5000,
        tries: 0,
        retryLimit: 3,
        dataType: 'json',
        data: options.data,
        success: options.succes,

        error: function(XMLHttpRequest) {
            this.tries++;
            if (this.tries <= this.retryLimit) {
                $.ajax(this);
                return;
            } else {
                alert("There was an error loading the JSON data. Error thrown was: " + XMLHttpRequest.statusText);
            }
        }
    });
};

Ideas.prototype.parseIdeas = function(data, options) {
    var $template,
        markupTemp = [],
        ideas = $.parseJSON(data)._embedded.ideas;
    for (var i = 0; i < ideas.length; i++) {
        var $idea = ich.idea(ideas[i]);
        markupTemp.push($idea);
    }

    $template = $.map(markupTemp, function(value, index) {
        return(value.get());
    });

    options.prependIdea($template);

};

Ideas.prototype.post = function(options) {
    $.ajax({
        url: '/api/5158bec53b77300134000001/ideas',
        type: 'POST',
        timeout: 5000,
        tries: 0,
        retryLimit: 3,
        data: { description: options.description },
        success: options.success,
        error: function(XMLHttpRequest) {
            this.tries++;
            if (this.tries <= this.retryLimit) {
                $.ajax(this);
                return;
            } else {
                alert("There was an error posting your idea. Error thrown was: " + XMLHttpRequest.statusText);
            }
        }
    });
};

var IdeasView = function(options) {
    this.ideas = options.ideas;
    var post = $.proxy(this.postStatus, this);
    var login = $.proxy(this.loginStatus, this);

    $('#new_idea').submit(post);
    $('#login_form').submit(login);
};

IdeasView.prototype.loginStatus = function(e) {
    e.preventDefault();
    var that = this;
    this.ideas.login({
        url: $('#login_form').attr('action'),
        data: {
            username: $('[name=username]').val(),
            password: $('[name=password]').val()
        },
        succes: function(data) {/*
            $('#login_form').fadeOut(function() {
                $('#new_idea').fadeIn();
                $('#ideas_').fadeIn(function() {
                    that.parseIdeas(data, options);
                });
            });*/
        }
    });
};

IdeasView.prototype.postStatus = function(e) {
    e.preventDefault();
    var that = this;
    this.ideas.post({
        description: $('#description').val(),
        success: function(data) {
            that.ideas.loadJSON(that);
            that.clearInput();
        }
    });
};

IdeasView.prototype.prependIdea = function(data) {
    $('#ideas').prepend(data);
    $('#ideas').removeClass('loading');
};

IdeasView.prototype.clearInput = function() {
    $('#description').val('').css('height', '2em');
};

$(document).delegate('textarea', 'keyup', function(event) {
    var self = $(this),
        textLineHeight = self.data('textLineHeight'),
        currentHeight = self.data('currentHeight'),
        startingHeight = this.scrollHeight,
        newHeight = this.scrollHeight;

    if (!textLineHeight) {
        textLineHeight = parseInt(self.css('line-height'),10);
        currentHeight = self.height();
        self.css('overflow','hidden');
    }

    if (newHeight > currentHeight) {
        newHeight = newHeight + 1 * textLineHeight;
        self.height(newHeight);
        self.data('currentHeight',newHeight);
    }
});

$(document).ready(function() {
    var ideas = new Ideas();

    new IdeasView({ ideas: ideas });
});
