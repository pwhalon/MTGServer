const userCardEntriesId = 'user-card-entries';
const successMessageId = 'transaction-success-messages';
const errorMessageId = 'transaction-success-messages';
var numberOfEntries = 1

function addCardEntry() {
    const addCardFormEntry = '<div class="row" id="entry-' + numberOfEntries + '"><div class="col-8 form-group">' +
        '<input type="text" id="name-' + numberOfEntries + '" class="form-control name" required name="cards[][name]">' +
        '</div><div class="col-2 form-group">' +
        '<input type="number" id="quantity-' + numberOfEntries + '" class="form-control quantity" required name="cards[][quantity]">' +
        '</div><div class="col-1 form-group">' +
        '<input type="number" id="box_number-' + numberOfEntries + '" class="form-control box_number" required name="cards[][box_number]">' +
        '</div><div class="col-1 form-group">' +
        '<input type="button" class="btn btn-danger" onclick="removeCardEntry(this)" value="-">' +
        '</div></div>';

    $('#' + userCardEntriesId).append(addCardFormEntry);
    numberOfEntries += 1;
}

function removeCardEntry(targetElement) {
    $(targetElement).parent().parent().remove()
    numberOfEntries -= 1;
}

function completeTransaction() {
    var transactionList = []
    var transactionEntry = {}

    const NAME = 'name';
    const QUANTITY = 'quantity';
    const BOX_NUMBER = 'box_number';
    const TRANSACTION_ENTRY = 'transaction_entry';

    for (var entry = 0; entry < numberOfEntries; entry++) {
        if ($('#entry-' + entry).length > 0) {
            transactionEntry[TRANSACTION_ENTRY] = 'entry-' + entry;
            transactionEntry[NAME] = $('#' + NAME + '-' + entry).val();
            transactionEntry[QUANTITY] = $('#' + QUANTITY + '-' + entry).val();
            transactionEntry[BOX_NUMBER] = $('#' + BOX_NUMBER + '-' + entry).val();
            transactionList.push(transactionEntry);
            transactionEntry = {};
        }
    }

    $.ajax({
        url: "/transaction/add_cards",
        type: "POST",
        data: { list: JSON.stringify(transactionList) },
        success: function(a) {
            flash(successMessageId, 'success', 'All cards successfully added!');
            $('#' + userCardEntriesId).empty();
            numberOfEntries = 1;
            addCardEntry();
        },
        error: function(response) {
            $.each(response['responseJSON'], function(index, entry) {
                //foreach of these check if theres an error
                if (entry['error']) {
                    flash(entry['transaction_entry'], 'danger', entry['error']);
                } else {
                    flash(successMessageId, 'success', entry['name']);
                }
            });
        }
    });
}