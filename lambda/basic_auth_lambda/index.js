
exports.handler = async (event, context, callback) => {
    const request = event.Records[0].cf.request;

    try {

        const headers = request.headers;

        const authUser = '${BASIC_USER}';
        const authPass = '${BASIC_PWD}';

        const authString = 'Basic ' + new Buffer(authUser + ':' + authPass).toString('base64');
        if (typeof headers.authorization === 'undefined' 
            || headers.authorization[0].value !== authString) {
            const body = 'Unauthorized';
            const response = {
                status: '401',
                statusDescription: 'Unauthorized',
                body: body,
                headers: {
                    'www-authenticate': [{key: 'WWW-Authenticate', value:'Basic'}]
                },
            };
            return callback(null, response);
        }
    }
    catch(e) {
        console.log(e);
    }
    return callback(null, request);
};
