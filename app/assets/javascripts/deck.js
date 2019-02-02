$(document).ready(function() {
    searchCards();
});


function searchCards () {
    $('.deckCardSearch').submit(function (e) {
        e.preventDefault();

        const form = $(this);
        const url = form.attr('action');
        const method = form.attr('method');
        const deckId = form.find('input[name="deckId"]').val();

        $.ajax({
            type: method,
            url: url,
            data: form.serialize(),
            dataType: 'script',
            beforeSend: function () {
                $(`#cardResults-${deckId}`).empty();
                $(`#cardResults-${deckId}`).append("<div class='spinner-border'><span class='sr-only'></span></div>");
            }
        });
    });
}

function addTransaction (deckId) {
    $(`#addCardsForm-${deckId}`).submit(function (e) {
        e.preventDefault();

        const form = $(this);
        const url = form.attr('action');
        const method = form.attr('method');

        $.ajax({
            type: method,
            url: url,
            data: form.serialize(),
            success: function(data) {
                $(`#addCardsModal-${deckId}`).modal('toggle');
            },
            error: function(event, error, status) {
                $(`#addCardsErrors-${deckId}`).empty();
                $(`#addCardsErrors-${deckId}`).html(`<div class='alert alert-danger alert-dismissable'>${event.responseJSON["errors"]}</div>`);
            }
        });
    });
}