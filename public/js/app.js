$(document).ready(function() {
    var ideas = new Ideas();

    new IdeasView({ ideas: ideas });

    $('#ideas_').hide();
    $('#new_idea').hide();
});

var Ideas = function() {};

var IdeasView = function(options) {
    this.ideas = options.ideas;
    var post = $.proxy(this.postStatus, this);
    var login = $.proxy(this.loginStatus, this);

    $('#new_idea').submit(post);
    $('#login_form').submit(login);
    $('body').on('click', '#review', this.reviewStatus);
    $('body').on('click', '#delete', this.deleteStatus);
    $('body').on('click', '#do', this.doStatus);
    $('body').on('click', '#complete', this.deleteStatus);
    $('body').on('click', '#schedule', this.scheduleStatus);
};

IdeasView.prototype.postStatus = function(e) {
    e.preventDefault();
    var that = this;
    this.ideas.request({
        url: $('#new_idea').attr('action'),
        data: { description: $('#description').val() },
        type: 'POST',
        success: function(data) {
            Ideas.prototype.loadJSON();
            that.clearInput();
        }
    });
};

IdeasView.prototype.loginStatus = function(e) {
    e.preventDefault();

    this.ideas.request({
        url: $('#login_form').attr('action'),
        type: 'POST',
        data: {
            username: $('[name=username]').val(),
            password: $('[name=password]').val()
        },
        success: function(data, options) {
            Ideas.prototype.parseIdeas(data, options);
            $('#new_idea').get(0).setAttribute('action', data._links.collect.href);
            $('.reload').attr('href', data._links.self.href);
            $('#login_form').fadeOut(function(data, options) {
                $('#date').datetimepicker({
                  dateFormat: 'yy/mm/dd'
                });
                $('#new_idea').fadeIn();
                $('#ideas_').fadeIn(function(data, options) {
                });
                setInterval(function() {
                  Ideas.prototype.loadJSON();
                }, 60000);

            });
        }
    });
};

IdeasView.prototype.deleteStatus = function(e) {
  e.preventDefault();
  var that = this;
  Ideas.prototype.request({
    url: $(this).data('action'),
    type: 'DELETE',
    success: function(data) {
      $(that).closest('li').fadeOut(function() {
        Ideas.prototype.loadJSON();
      });
    }
    });
};

IdeasView.prototype.reviewStatus = function(e) {
    e.preventDefault();
    var that = this;
    Ideas.prototype.request({
        url: $(this).data('action'),
        type: 'PUT',
        success: function(data) {
            $(that).closest('li').hide();
            Ideas.prototype.loadJSON();
        }
    });
};

IdeasView.prototype.doStatus = function(e) {
    e.preventDefault();
    var that = this;
    Ideas.prototype.request({
        url: $(this).data('action'),
        type: 'PUT',
        success: function(data) {
            $(that).closest('li').hide();
            Ideas.prototype.loadJSON();
        }
    });
};

IdeasView.prototype.scheduleStatus = function(e) {
    e.preventDefault();
    var that = this;
    Ideas.prototype.request({
        url: $(this).data('action'),
        data: {datetime: $('#date').val() + " CDT"},
        type: 'PUT',
        success: function(data) {
            $(that).closest('li').hide();
            Ideas.prototype.loadJSON();
        }
    });
};

Ideas.prototype.request = function(options) {
    $.ajax({
        url: options.url,
        type: options.type,
        timeout: 5000,
        data: options.data,
        dataType: 'json',
        success: options.success,
        beforeSend: options.beforeSend,
        error: function(XMLHttpRequest) {
          alert("Error in request: " + XMLHttpRequest.statusText);
        }
    });
};

Ideas.prototype.loadJSON = function() {
  this.request({
    url: $('.reload').attr('href'),
    type: 'GET',
    beforeSend: function() {
      $('#ideas').find('li').remove();
      $('#ideas').show();
      $('#ideas').addClass('loading');
    },
    success: function(data, options) {
      Ideas.prototype.parseIdeas(data, options);
      $('#date').datetimepicker({
        dateFormat: 'yy/mm/dd'
      });
    }
  });
};

Ideas.prototype.parseIdeas = function(data, options) {
    var $template, markupTemp = [], ideas = data._embedded.ideas;

    if (ideas.length > 0) {
        var $idea = ich.idea(ideas[0]);
        markupTemp.push($idea);
        $template = $.map(markupTemp, function(value, index) {
            return(value.get());
        });

        IdeasView.prototype.prependIdea($template);
    }
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
