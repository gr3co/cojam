require('cloud/app.js');

Parse.Cloud.beforeSave("Room", function(request, response) {
    if (!request.object.get("idNumber")) {
        request.object.set("idNumber", Math.random().toString(36).replace(/[^a-z]+/g, '').substr(0, 10));
    }
    response.success();
});