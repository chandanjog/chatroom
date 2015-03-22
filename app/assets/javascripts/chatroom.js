APP.ChatMessages = function () {
    var websocketPostsChannel = new WebSocketRails(APP.websocketEndpoint).subscribe('posts');
    var commentsSection = $(".user_posts");


    var updateOnNewComment = function () {
        websocketPostsChannel.bind('new', function(post) {
            commentsSection.prepend($(post).fadeIn());
            commentsSection.scrollTop(0);
        });
    };

    return{
        updateOnNewComment: updateOnNewComment
    };
};

APP.ActiveUsersList = function () {
    var websocketActiveUsersChannel = new WebSocketRails(APP.websocketEndpoint).subscribe('active_usernames');
    var activeUsersList = $(".active_users");

    var keepUpdated = function(){
        websocketActiveUsersChannel.bind('add', function(html) {
            activeUsersList.prepend($(html).fadeIn());
        });

        websocketActiveUsersChannel.bind('remove', function(username) {
            activeUsersList.find('li#' + username).remove();
        });

        websocketActiveUsersChannel.bind('refresh_all', function(html) {
            activeUsersList.html($(html).fadeIn());
        });
    ;}

    return{
        keepUpdated: keepUpdated
    }
}

APP.CommentBox = function () {
    var submitButton = $('#post_comment');
    var inputTextArea = $('#user_comment');

    var errorSection = $('#comment_error');
    var emptyCommentErrorMsg = 'Cannot post empty message';
    var serverErrorPostingComment = 'Something went wrong posting your comment. Try again.';

    var postOnClick = function () {
        submitButton.click(function () {
            validateAndCallServer();
        });
        return APP.CommentBox();
    }

    var postOnEnterKeypress = function(){
        inputTextArea.keypress(function(e) {
            if(e.which == 13) {
                validateAndCallServer();
            }
        });
        return APP.CommentBox();
    }

    function validateAndCallServer(){
        inputTextArea.prop('disabled', true);
        var message = inputTextArea.val();
        if (message === "") {
            errorSection.text(emptyCommentErrorMsg).show();
            inputTextArea.prop('disabled', false);
        }
        else{
            $.ajax({
                type: "POST",
                url: '/chatroom',
                data: {
                    message: $('#user_comment').val()
                },
                success: function (data) {
                    errorSection.hide();
                    inputTextArea.val('');
                    inputTextArea.prop('disabled', false);
                },
                error: function () {
                    errorSection.text(serverErrorPostingComment).show();
                    inputTextArea.prop('disabled', false);
                }
            });
        }
    }

    return{
        postOnClick: postOnClick,
        postOnEnterKeypress: postOnEnterKeypress
    };
}
