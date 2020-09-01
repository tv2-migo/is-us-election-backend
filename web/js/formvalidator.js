(function ($) {
    $.fn.efv = function () {
        //Defalut settings
        var defaults = {
            disableSubmit: true,
            invalidColor: "#da3116",
            validColor: "#22bb5b",
            submitButtonId: "#form-submit"
        };

        var settings = $.extend({}, defaults);
        
        var elements = new Array();

        //Private methodes
        function validate() {
            var isValid = true;
            $.each(elements, function( index, value ) {
                if($(value).attr("data-isvalid") === "false") {
                    isValid = false;
                }
            });
            
            if (isValid === true) {
                $(settings.submitButtonId).prop("disabled",false);
            } else {
                $(settings.submitButtonId).prop("disabled",true);
            }
        };

        function validateInputAgainstList(elm, keys) {
            inputValue = $(elm).val();
            if ($.inArray(inputValue, keys) !== -1 || $(elm).val() === "") {
                $(elm).css("border-color", settings.invalidColor);
                $(elm).attr("data-isvalid", "false");
            } else {
                $(elm).css("border-color", settings.validColor);
                $(elm).attr("data-isvalid", "true");
            }
            validate();
        };

        function notEmpty(elm) {
            if ($(elm).val() === "") {
                $(elm).css("border-color", settings.invalidColor);
                $(elm).attr("data-isvalid", "false");
            } else {
                $(elm).css("border-color", settings.validColor);
                $(elm).attr("data-isvalid", "true");
            }
            validate();
        };

        function validateSelect(field) {
            if ($(field).val() === "" || $(field).val() === null) {
                $(field).css("border-color", settings.invalidColor);
                $(field).attr("data-isvalid", "false");
            } else {
                $(field).css("border-color", settings.validColor);
                $(field).attr("data-isvalid", "true");
            }
            validate();
        };

        function onSubmit(field) {
            $(field).click(function () {
                
            });
        };

        //Public methodes
        return {
            validateForm: function (fields, options) {
                settings = $.extend({}, defaults, options);
                
                if (settings.disableSubmit === true) {
                    $(settings.submitButtonId).prop("disabled",true);
                }
                
                $.each(fields, function (index, value) {
                    elements.push(value.field);
                    if (value.method === "notEmpty") {
                        $(value.field).change(function () {
                            notEmpty(value.field);
                        });
                        notEmpty(value.field);
                    }

                    if (value.method === "validateInputAgainstList") {
                        $(value.field).change(function () {
                            validateInputAgainstList(value.field, value.list);
                        });
                        validateInputAgainstList(value.field, value.list);
                    }

                    if (value.method === "validateSelect") {
                        $(value.field).change(function () {
                            validateSelect(value.field);
                        });
                        validateSelect(value.field);
                    }

                    if (value.method === "onSubmit") {
                        onSubmit(value.field);
                    }

                });
                
                validate();
            }
        };
    };

})(jQuery);




