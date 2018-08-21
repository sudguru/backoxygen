var express = require('express');
var router = express.Router();
var jwt = require('jsonwebtoken');

// router.get('/', verifyToken, function(req, res, next) {
router.get('/', function(req, res, next) {
    res.locals.connection.query('SELECT * from products order by name', function (error, results, fields) {
    		if (error) {
          res.json({status: 500, error: error.message, data: null })
        } else {
          res.json({status: 200, error: null, data: results});
        }
    });
});

router.post('/', function(req, res, next) {
    var product = req.body.product;
    var parties = req.body.parties;
    console.log(product);
    console.log(parties);
    res.locals.connection.query('INSERT INTO products SET ?', product , function (error, results, fields) {
        product.id = results.insertId;
        if (error) {
          res.json({status: 500, error: error.message, data: null })
        } else {
          parties.forEach(party => {
            const product_price = {
              product_id: product.id,
              party_id: party.id,
              rate: product.base_rate
            }
            res.locals.connection.query('INSERT INTO product_price SET ?', product_price);
          });
          res.json({status: 200, error: null, data: true});
        }
    });
});

router.post('/edit/:id', function(req, res, next) {
    //console.log('sdf', req.body.product);
    const product = req.body.product;
    const id = req.params.id;
    res.locals.connection.query('UPDATE products SET ? where id = ?', [ product, id ] , function (error, results, fields) {
        if (error) {
          res.json({status: 500, error: error.message, data: null })
        } else {
          res.json({status: 200, error: null, data: true});
        }
    });
});





router.delete('/:id', function(req, res, next) {
  console.log(req.params.id);

  res.locals.connection.query('DELETE FROM products where id = ?', [ req.params.id ], function (error, results, fields) {
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
