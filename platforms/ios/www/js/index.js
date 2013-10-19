// Generated by CoffeeScript 1.6.3
(function() {
  $(function() {
    var fail, fileURI, onFail, onSuccess, takePicture, win;
    $('#pictures').live('pageshow', function() {
      var myPhotoSwipe;
      console.log("Setting up gallery");
      myPhotoSwipe = $("#Gallery a").photoSwipe({});
      return true;
    });
    fileURI = "res/screen/windows-phone/screen-portrait.jpg";
    win = function(r) {
      console.log("Code = " + r.responseCode);
      console.log("Response = " + r.response);
      return console.log("Sent = " + r.bytesSent);
    };
    fail = function(error) {
      console.log("upload error source " + error.source);
      return console.log("upload error target " + error.target);
    };
    onSuccess = function(image_url) {
      var ft, options, params;
      console.log("uploading pictures");
      console.log(image_url);
      options = new FileUploadOptions();
      console.log("Setting fileKey");
      options.fileKey = "image[image]";
      console.log("fileKey was set.");
      options.fileName = image_url.substr(image_url.lastIndexOf('/') + 1);
      options.mimeType = "image/jpeg";
      options.chunkedMode = false;
      console.log("fileName was set!, ");
      console.log(options.fileName);
      params = new Object();
      params.act_code = "vgyukm";
      params['image[name]'] = "From mobilephone";
      console.log("Setting params");
      options.params = params;
      console.log(options);
      console.log("wuuuu it went through");
      if (true) {
        return ft = new FileTransfer();
      } else {
        return console.log("Took false branch...");
      }
    };
    onFail = function(message) {
      return console.log('Failed because: ' + message);
    };
    takePicture = function() {
      return navigator.camera.getPicture(onSuccess, onFail, {
        quality: 50,
        destinationType: Camera.DestinationType.FILE_URI,
        sourceType: navigator.camera.PictureSourceType.PHOTOLIBRARY
      });
    };
    return $('#take_picture_button').click(function() {
      console.log("Taking picture.");
      return takePicture();
    });
  });

}).call(this);