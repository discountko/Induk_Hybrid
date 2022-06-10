(function () {
    $('.messages').animate({ scrollTop: $('.messages').prop('scrollHeight') }, 0);

    var Message;
    Message = function (arg) {
        this.text = arg.text, this.message_side = arg.message_side;
        this.author = arg.author, this.create_date = arg.create_date;
        this.draw = function (_this) {
            return function () {
                var $message;
                $message = $($('.message_template').clone().html());
                $message.addClass(_this.message_side).find('.text').html(_this.text);
                $message.find('.user').html(_this.text);
                $('.messages').append(_this.author);
                $('.time').append(_this.create_date);

                return setTimeout(function () {
                    return $message.addClass('appeared');
                }, 0);
            };
        }(this);
        return this;
    };
    $(function () {
        var getMessageText, message_side, sendMessage;
        message_side = 'right';
        getMessageText = function () {
            var $message_input;
            $message_input = $('.message_input');
            return $message_input.val();
        };
        sendMessage = function (data) {
            var $messages, message;

            var isMyComment = "N";
            if(data.author == user){
                isMyComment = "Y";
            }

            if (text.trim() === '') {
                return;
            }
            //$('.message_input').val('');
            $messages = $('.messages');
            message_side = isMyComment === 'Y' ? 'right' : 'left';
            message = new Message({
                create_date: data.create_date,
                author: data.author,
                text: data.comment,
                message_side: message_side
            });
            message.draw();
            return $messages.animate({ scrollTop: $messages.prop('scrollHeight') }, 0);
        };
        /*
        $('.send_message').click(function (e) {
            return sendMessage(data);
        });
        $('.message_input').keyup(function (e) {
            if (e.which === 13) {
                return sendMessage(data);
            }
        });
        */
    });
}.call(this));