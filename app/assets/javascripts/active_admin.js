//= require arctic_admin/base
//= require upload_manager.js
//= require active_admin/searchable_select
//= require activeadmin_addons/all
//= require activeadmin/dynamic_fields
//= require active_admin_datetimepicker


$(document).ready(function () {
    $(document).on('select2:open', () => {
        document.querySelector('.select2-search__field').focus();
    });
})

