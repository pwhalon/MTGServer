function addCardEntry() {
    const addCardFormId = 'add-cards-form';

    const addCardFormEntry = '<div class="row"><div class="col-8 form-group">' +
        '<input type="text" class="form-control" required name="cards[][name]">' +
        '</div><div class="col-2 form-group">' +
        '<input type="number" class="form-control" required name="cards[][quantity]">' +
        '</div><div class="col-1 form-group">' +
        '<input type="number" class="form-control" required name="cards[][box_number]">' +
        '</div><div class="col-1 form-group">' +
        '<input type="button" class="btn btn-info" onclick="addCardEntry()" value="+">' +
        '</div></div>'

    $('#' + addCardFormId).append(addCardFormEntry);
}