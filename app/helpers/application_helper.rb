module ApplicationHelper
    def flash_messages_for(object)
        render(:partial => 'pages/flash_messages', :locals => {:object => object})
     end
end
