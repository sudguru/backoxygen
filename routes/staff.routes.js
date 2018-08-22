var express = require('express');
var router = express.Router();
var jwt = require('jsonwebtoken');



router.get('/:party_id', function(req, res, next) {
    console.log('here')
		var party_id = req.params.party_id;
    res.locals.connection.query('SELECT * from staffs where party_id = ? order by name', party_id,  function (error, results, fields) {
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
    var staff = req.body.staff;
    res.locals.connection.query('INSERT INTO staffs SET ?', staff , function (error, results, fields) {
    		staff.id = results.insertId;
        if (error) {
          console.log(error);
          res.json({status: 500, error: error.message, data: null })
        } else {
          res.json({status: 200, error: null, data: staff});
        }
    });
});


router.post('/edit/:id', function(req, res, next) {
    const staff = req.body.staff;
    const id = req.params.id;
    res.locals.connection.query('UPDATE staffs SET ? where id = ?', [ staff, id ] , function (error, results, fields) {
        if (error) {
          res.json({status: 500, error: error.message, data: null })
        } else {
          res.json({status: 200, error: null, data: true});
        }
    });
});



router.delete('/:id', function(req, res, next) {
  console.log(req.params.id);

  res.locals.connection.query('DELETE FROM staffs where id = ?', [ req.params.id ], function (error, results, fields) {
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
