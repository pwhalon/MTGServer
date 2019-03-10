function flash(id, type, message) {
    var flash_element = '<div class="alert alert-' + type + ' alert-dismissable">' +
    message +
    '<button type="button" class="close" data-dismiss="alert" aria-label="Close">' +
    '<span aria-hidden="true">&times;</span></button></div>';
    $('#' + id).html(flash_element);
}

function autoComplete(className, sourceNames) {
    const inputFields = $('.' + className);

    inputFields.autocomplete({
        source: sourceNames,
        minLength: 2
    })
}

function setupAutocomplete(className) {
    cardNames = [];

    $.ajax({
        url: '/magic_card/names',
        type: 'GET',
        success: function (data) {
            autoComplete(className, data);
        },
        error: function () {
            cardNames = [];
        }
    });
}