$(document).ready(function() {
    searchCards();
    ACTIVE_URL = new URL(document.URL);
});

var ACTIVE_URL;
var ACTIVE = "active";

function setActiveDeck(deckId) {
    ACTIVE_URL.searchParams.set(ACTIVE, deckId)
    window.history.pushState({ ACTIVE : deckId }, "Updated active deck", ACTIVE_URL.search);
}

function deckAutocomplete() {
    var cardNames = [];
    const autocompleteClass = 'autocomplete-name';

    $.ajax({
        url: '/my_cards/names',
        type: 'GET',
        success: function (data) {
            inputFields.autocomplete({
                source: sourceNames,
                minLength: 2
            });
        },
        error: function () {
            cardNames = [];
        }
    });
}

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
    $(`#moveCardsForm-${deckId}`).submit(function (e) {
        e.preventDefault();

        const form = $(this);
        const url = form.attr('action');
        const method = form.attr('method');

        $.ajax({
            type: method,
            url: url,
            data: form.serialize(),
            success: function(data) {
                $(`#moveCardsModal-${deckId}`).modal('toggle');
            },
            error: function(event, error, status) {
                $(`#moveCardsErrors-${deckId}`).empty();
                $(`#moveCardsErrors-${deckId}`).html(`<div class='alert alert-danger alert-dismissable'>${event.responseJSON["errors"]}</div>`);
            }
        });
    });
}

function showCardDetails(box, rarity, mana_cost, card_type, multiverse_id, image_url, deck_id) {
    $(`#cardPreview-${deck_id}`).html(
        `<div class="card text-white bg-dark mb-3" style="max-width: 18rem;">
            <div class="card-body">
                <p class="card-text">Card Type: ${card_type}</p>
                <p class="card-text">Mana Cost: ${mana_cost}</p>
                <p class="card-text">Rarity: ${rarity}</p>
                <p class="card-text">Multiverse Id: ${multiverse_id}</p>
                <p class="card-text">Box Location: ${box}</p>
                <img class="full-height"
                    src="_dos_prevention_<%= magic_card.image_url %>"
                    alt="Image for <%= card.name %> not available"
                    onerror="this.src='/assets/magic_card_back.jpg'">
            </div>
        </div>`
    )
}