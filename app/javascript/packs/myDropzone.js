window.Dropzone = require('dropzone/dist/min/dropzone.min');


Dropzone.autoDiscover = false;
var addDropzone = function(){
  $(".upload-image").each(function(){
    // var type = $(this).data('type');
    $(this).dropzone({
      url: "/recipes/new",
      addRemoveLinks: true,
      maxFilesize: 10,
      autoProcessQueue: false,
      uploadMultiple: true,
      parallelUploads: 4,
      maxFiles: 4,
      previewsContainer: ".dropzone-previews",
      clickable: ".upload-image-icon",
      thumbnailWidth: 100,
      thumbnailHeight: 100,
    })
  })
}
$(document).ready(function(){
  addDropzone();
  $('#steps').on('cocoon:after-insert', addDropzone);
})