function flash(id, type, message) {
    var flash_element = '<div class="alert alert-' + type + ' alert-dismissable">' +
    message +
    '<button type="button" class="close" data-dismiss="alert" aria-label="Close">' +
    '<span aria-hidden="true">&times;</span></button></div>';
    $('#' + id).append(flash_element);
}