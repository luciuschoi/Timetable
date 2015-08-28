 function showLecture(lec_num)
  {
      <% if user_login? %>
        <% if current_user.valuations.count>2 %>
          $.fancybox({
            type: 'iframe',
            href: '/lectures/'+lec_num.toString(),
              'scrolling' : 'yes',
                'padding' : 20,
                'width'   :1200,
                'height'  :600,
                'transitionIn'    :    'none',
                'transitionOut'    :    'none',
                'speedIn'        :    400,
                'speedOut'        :    200,
                'autoDimensions'  : false,
                'overlayShow'    :    true

          });
         <% else %>
         window.location="http://192.168.0.200:3003/forcingwritting"
         <% end %>  
       <% else %>
          $.fancybox({
            type: 'iframe',
            href: '/forcinglogin',
              'scrolling' : 'yes',
                'padding' : 20,
                'width'   :1200,
                'height'  :600,
                'transitionIn'    :    'none',
                'transitionOut'    :    'none',
                'speedIn'        :    400,
                'speedOut'        :    200,
                'autoDimensions'  : false,
                'overlayShow'    :    true

          });
       <% end %>        
  }