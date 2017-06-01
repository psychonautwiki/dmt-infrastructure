const level = require('level');
const db = level('/tmp/data');

const bodyParser = require('body-parser')
const express = require('express');
const app = express();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.post('/ingress', (req, res) => {
	if (!Array.isArray(req.body)) return;

	req.body.forEach(line =>
		db.put(
			process.hrtime().concat(Date.now()).join('\xFF'),
			line
		)
	);

    res.end();
});

app.get('REMOVED', (req, res) =>
	db.createValueStream()
          .on('data', line => res.write(`${line}\n`))
          .on('end', () => res.end())
);

app.listen(80);
