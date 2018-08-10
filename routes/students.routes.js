var express = require('express');
var router = express.Router();
var jwt = require('jsonwebtoken');


router.get('/', verifyToken, function(req, res, next) {
    res.locals.connection.query('SELECT * from students order by name', function (error, results, fields) {
    		if (error) throw error;
    		res.json({status: 200, error: null, data: results});
    });
});

router.get('/list', verifyToken, function(req, res, next) {
    //const sql = 'SELECT sid, name, phone, CONCAT(classes.classname,'-',section) as class, rollnumber, status from students inner join classes on students.currentclasssn = classes.sn';
    res.locals.connection.query('SELECT sid, name, phone, classname, section, rollnumber, status from students inner join classes on students.currentclasssn = classes.sn', function (error, results, fields) {
        // console.log(sql);
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
