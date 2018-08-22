var express = require('express');
var router = express.Router();
var jwt = require('jsonwebtoken');



router.get('/', function(req, res, next) {
    res.locals.connection.query('SELECT * from containers order by name',  function (error, results, fields) {
    		if (error) {
    			console.log(error);
          res.json({status: 500, error: error.message, data: null })
        } else {
          console.log(results);
          res.json({status: 200, error: null, data: results});
        }
    });
});

router.post('/', function(req, res, next) {
    var container = req.body.container;
    res.locals.connection.query('INSERT INTO containers SET ?', container , function (error, results, fields) {
    		container.id = results.insertId;
        if (error) {
          console.log(error);
          res.json({status: 500, error: error.message, data: null })
        } else {
          res.json({status: 200, error: null, data: container});
        }
    });
});


router.post('/edit/:id', function(req, res, next) {
    const container = req.body.container;
    const id = req.params.id;
    res.locals.connection.query('UPDATE containers SET ? where id = ?', [ container, id ] , function (error, results, fields) {
        if (error) {
          res.json({status: 500, error: error.message, data: null })
        } else {
          res.json({status: 200, error: null, data: true});
        }
    });
});



router.delete('/:id', function(req, res, next) {
  console.log(req.params.id);

  res.locals.connection.query('DELETE FROM containers where id = ?', [ req.params.id ], function (error, results, fields) {
    if (error) throw error;
    res.json({status: 200, error: null, data: true});
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
