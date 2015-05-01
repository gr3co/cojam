require('cloud/app.js');

Parse.Cloud.beforeSave("CJRoom", function(request, response) {
    if (!request.object.get("idNumber")) {
        request.object.set("idNumber", Math.random().toString(36).replace(/[^a-z]+/g, '').substr(0, 8));
    }
    response.success();
});