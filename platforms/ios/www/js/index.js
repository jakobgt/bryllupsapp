// Generated by CoffeeScript 1.3.3
(function() {

  $(function() {
    var channel, fail, insert_picture, onFail, pusher, takePicture, uploadPictureFromLibrary, upload_picture, win;
    $('#pictures').live('pageshow', function() {
      console.log("Setting up gallery");
      return true;
    });
    insert_picture = function(data) {
      var anchor_elm, img_elm, li_elm, medium_thumb_url, small_thumb_url, title;
      console.log("Date is: " + data);
      small_thumb_url = "http://www.lineogjakob.dk" + data.small_thumb_url;
      medium_thumb_url = "http://www.lineogjakob.dk" + data.medium_thumb_url;
      title = "Fra: " + data.guest.first_name;
      if (data.guest.last_name) {
        title += " " + data.guest.last_name.substring(0, 1) + ".";
      }
      console.log("Creating elements.");
      img_elm = document.createElement('img');
      img_elm.src = small_thumb_url;
      img_elm.alt = title;
      anchor_elm = document.createElement('a');
      anchor_elm.href = medium_thumb_url;
      anchor_elm.ref = 'external';
      anchor_elm.appendChild(img_elm);
      li_elm = document.createElement('li');
      li_elm.appendChild(anchor_elm);
      $(li_elm).clone().hide().prependTo($('#Gallery')).slideDown();
      return console.log("Inserting the picture.");
    };
    win = function(response) {
      insert_picture($.parseJSON(response.response));
      console.log("Code = " + response.responseCode);
      console.log("Response = " + response.response);
      return console.log("Sent = " + response.bytesSent);
    };
    fail = function(error) {
      console.log("upload error source " + error.source);
      return console.log("upload error target " + error.target);
    };
    upload_picture = function(image_url) {
      var ft, liitem, options, params;
      console.log("uploading picture: " + image_url);
      options = new FileUploadOptions();
      options.fileKey = "image[image]";
      options.fileName = image_url.substr(image_url.lastIndexOf('/') + 1);
      options.mimeType = "image/jpeg";
      params = new Object();
      params.act_code = "vgyukm";
      params['image[name]'] = "From mobilephone";
      options.params = params;
      liitem = document.createElement('li');
      $('.status_bar').append(liitem);
      ft = new FileTransfer();
      ft.onprogress = function(progressEvent) {
        var perc;
        if (progressEvent.lengthComputable) {
          perc = Math.floor(progressEvent.loaded / progressEvent.total * 100);
          return liitem.innerHTML = perc + "% uploaded...";
        } else {
          if (liitem.innerHTML === "") {
            return liitem.innerHTML = "Uploading";
          } else {
            return liitem.innerHTML += ".";
          }
        }
      };
      ft.upload(image_url, encodeURI("http://www.lineogjakob.dk/images.json"), (function(r) {
        $(liitem).remove();
        return win(r);
      }), (function(r) {
        $(liitem).remove();
        return fail(r);
      }), options);
      return console.log("Started the upload.");
    };
    onFail = function(message) {
      return console.log('Failed because: ' + message);
    };
    takePicture = function() {
      return navigator.camera.getPicture(upload_picture, onFail, {
        quality: 50,
        targetWidth: 1600,
        targetHeight: 1600,
        destinationType: Camera.DestinationType.FILE_URI,
        sourceType: navigator.camera.PictureSourceType.CAMERA,
        saveToPhotoAlbum: true,
        correctOrientation: true
      });
    };
    uploadPictureFromLibrary = function() {
      return navigator.camera.getPicture(upload_picture, onFail, {
        quality: 50,
        targetWidth: 1600,
        targetHeight: 1600,
        destinationType: Camera.DestinationType.FILE_URI,
        sourceType: navigator.camera.PictureSourceType.PHOTOLIBRARY
      });
    };
    $('#take_picture_button').click(function() {
      console.log("Taking picture.");
      return takePicture();
    });
    $('#upload_picture_button').click(function() {
      console.log("Uploading picture.");
      return uploadPictureFromLibrary();
    });
    Pusher.log = function(message) {
      if (window.console && window.console.log) {
        return window.console.log(message);
      }
    };
    pusher = new Pusher('542416e0dcbaf6b1fb39');
    channel = pusher.subscribe('pictures');
    return channel.bind('new_picture', function(data) {
      return insert_picture($.parseJSON(data.message));
    });
  });

}).call(this);
