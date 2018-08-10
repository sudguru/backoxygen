var express = require('express');
var router = express.Router();
var jwt = require('jsonwebtoken');

// router.get('/', verifyToken, function(req, res, next) {
router.get('/', function(req, res, next) {
    res.locals.connection.query('SELECT * from products order by name', function (error, results, fields) {
    		if (error) throw error;
    		res.json({status: 200, error: null, data: results});
    });
});


//verify verifyToken
function verifyToken(req, res, next) {
  // get auth header
  const bearerHeader = req.headers['authorization'];
  console.log(bearerHeader);
  if(typeof bearerHeader !== 'undefined') {
      const bearerToken = bearerHeader.split(' ')[1];
      jwt.verify(bearerToken, 'secretsuper', (err, authData) => {
        if(err) {
            res.sendStatus(403);
        } else {
            next();
        }
      });
  } else {
    res.sendStatus(403);
  }
}

module.exports = router;
