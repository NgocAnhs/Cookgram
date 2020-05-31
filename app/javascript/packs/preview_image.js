function previewFiles(previews, files, height, width) {
  previews.innerHTML='';

  function readAndPreview(file) {
    // Make sure `file.name` matches our extensions criteria
    if ( /\.(jpe?g|png|gif)$/i.test(file.name) ) {
      var reader = new FileReader();
      
      reader.addEventListener("load", function () {
        var image = new Image();
        image.height = height;
        image.width = width;
        image.title = file.name;
        image.src = this.result;
        image.style.objectFit = 'cover'
        image.className = 'base-border-rounded';
        previews.appendChild( image );
      }, false);

      reader.readAsDataURL(file);
    }

  }

  if (files) {
    [].forEach.call(files, readAndPreview);
  }

}

function overLimitImage(max_file_number, file_upload){
  var number_of_image = $(file_upload)[0].files.length;
  return number_of_image > max_file_number;
}

$(document).on('turbolinks:load', function() {
  if ($('.recipes.new').length) {
    var step_input = $('#steps').find('input:file');
    var thumb_input = $('#image-recipe-label').find('input:file');
    var previews = $(this).find('.preview');
    step_input.change(function(){
      if (overLimitImage(4, step_input)){
        alert("You can't upload over 4 files.")
        $(step_input).val('');
      }
      previewFiles(previews[1], step_input[0].files, 100, 100);
    });

    thumb_input.change(function(){
      previewFiles(previews[0], thumb_input[0].files, 340, 600);
    });
    
    $('#steps')
    .on('cocoon:after-insert', function(e, added_task) {
      var input_file = $(added_task).find('input:file');
      var preview_added = $(added_task).find('.preview');
      input_file.change(function(){
        if (overLimitImage(4, input_file)){
          alert("You can't upload over 4 files.")
          $(input_file).val('');
        }
        previewFiles(preview_added[0], input_file[0].files, 100, 100);
      });
    });
  }
});
