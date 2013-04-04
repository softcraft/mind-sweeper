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
        success: options.success,
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

Ideas.prototype.loadJSON = function(options) {
  var that = this;

  $.ajax({
        url: $('.reload').attr('href'),
        type: 'GET',
        timeout: 5000,
        dataType: 'json',
        tries: 0,
        retryLimit: 3,
        beforeSend: function() {
            $('#ideas').find('li').remove();
            $('#ideas').show();
            $('#ideas').addClass('loading');
        },
        success: function(data, options) {
            Ideas.prototype.parseIdeas(data, options);
        },
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

Ideas.prototype.post = function(options) {
    $.ajax({
        url: options.url,
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

Ideas.prototype.delete = function(options) {
    $.ajax({
        url: options.url,
        type: 'DELETE',
        timeout: 5000,
        tries: 0,
        retryLimit: 3,
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

Ideas.prototype.review = function(options) {
    $.ajax({
        url: options.url,
        type: 'PUT',
        timeout: 5000,
        tries: 0,
        retryLimit: 3,
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

Ideas.prototype.parseIdeas = function(data, options) {
    var $template, markupTemp = [], ideas = data._embedded.ideas;
    
    //for (var i = 0; i < ideas.length; i++) {
    if (ideas.length > 0) {
        var $idea = ich.idea(ideas[0]);
        markupTemp.push($idea);
    //}

        $template = $.map(markupTemp, function(value, index) {
            return(value.get());
        });

        IdeasView.prototype.prependIdea($template);
    }
};


var IdeasView = function(options) {
    this.ideas = options.ideas;
    var post = $.proxy(this.postStatus, this);
    var login = $.proxy(this.loginStatus, this);
    
    $('#new_idea').submit(post);
    $('#login_form').submit(login);
    $('body').on('click', '#review', this.reviewStatus);
    $('body').on('click', '#delete', this.deleteStatus);
    $('body').on('click', '#complete', this.deleteStatus);
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
        success: function(data, options) {
            Ideas.prototype.parseIdeas(data, options);
            $('#new_idea').get(0).setAttribute('action', data._links.collect.href);
            $('.reload').attr('href', data._links.self.href);
            $('#login_form').fadeOut(function(data, options) {
                $('#new_idea').fadeIn();
                $('#ideas_').fadeIn(function(data, options) {
                });
            });
        }
    });
};

IdeasView.prototype.postStatus = function(e) {
    e.preventDefault();
    var that = this;
    this.ideas.post({
        url: $('#new_idea').attr('action'),
        description: $('#description').val(),
        success: function(data) {
            Ideas.prototype.loadJSON(that);
            that.clearInput();
        }
    });
};

IdeasView.prototype.deleteStatus = function(e) {
    e.preventDefault();
    var that = this;
    Ideas.prototype.delete({
        url: $(this).data('action'),
        success: function(data) {
            $(that).closest('li').fadeOut(function() {
                Ideas.prototype.loadJSON(that);
            });
        }
    });
};

IdeasView.prototype.reviewStatus = function(e) {
    e.preventDefault();
    var that = this;
    Ideas.prototype.review({
        url: $(this).data('action'),
        success: function(data) {
            $(that).closest('li').hide();
            Ideas.prototype.loadJSON(that);
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

    $('#ideas_').hide();
    $('#new_idea').hide();
});
