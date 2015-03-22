$(document).ready(function(){
    APP.ChatMessages().updateOnNewComment();
    APP.CommentBox().postOnClick().postOnEnterKeypress();
    APP.ActiveUsersList().keepUpdated();
});
