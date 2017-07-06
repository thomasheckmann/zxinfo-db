/**

SELECT
    d.id as download_id,
    e.id as entry_id,
    e.title as title,
    d.file_link as file_link,
    ft.text as filetype,
    ftt.text as formattype
FROM downloads d
    INNER JOIN entries e ON e.id = d.entry_id
    LEFT JOIN filetypes ft on ft.id = d.filetype_id
    LEFT JOIN formattypes ftt on ftt.id = d.formattype_id
WHERE
    d.file_link IS NOT NULL
ORDER BY title ASC, filetype, formattype

+-------------+----------+-----------------------------+-------------------------------------------------------------+----------------------+--------------------+
| download_id | entry_id | title                       | file_link                                                   | filetype             | formattype         |
+-------------+----------+-----------------------------+-------------------------------------------------------------+----------------------+--------------------+
| 58828       | 11853    | "O" Level Revision: Physics | /pub/sinclair/games-inlays/o/OLevelRevision-Physics.jpg     | Cassette inlay       | Picture            |
| 58825       | 11853    | "O" Level Revision: Physics | /pub/sinclair/screens/in-game/o/OLevelRevision-Physics.gif  | In-game screen       | Picture            |
| 58826       | 11853    | "O" Level Revision: Physics | /pub/sinclair/games-info/o/OLevelRevision-Physics.txt       | Instructions         | Text document      |
| 58823       | 11853    | "O" Level Revision: Physics | /pub/sinclair/screens/load/o/gif/OLevelRevision-Physics.gif | Loading screen       | Picture            |
| 58824       | 11853    | "O" Level Revision: Physics | /pub/sinclair/screens/load/o/scr/OLevelRevision-Physics.scr | Loading screen       | Screen dump        |
| 58827       | 11853    | "O" Level Revision: Physics | /pub/sinclair/games-info/o/OLevelRevision-Physics.zip       | Scanned instructions | NULL               |
| 58822       | 11853    | "O" Level Revision: Physics | /pub/sinclair/games/o/OLevelRevision-Physics.tap.zip        | Tape image           | (non-TZX) TAP tape |
| 58821       | 11853    | "O" Level Revision: Physics | /pub/sinclair/games/o/OLevelRevision-Physics.tzx.zip        | Tape image           | Perfect TZX tape   |
| 99080       | 27504    | "Parus" Copier              | /pub/sinclair/screens/in-game/p/ParusCopier.gif             | In-game screen       | Picture            |
| 99078       | 27504    | "Parus" Copier              | /pub/sinclair/screens/load/p/gif/ParusCopier.gif            | Loading screen       | Picture            |
| 99079       | 27504    | "Parus" Copier              | /pub/sinclair/screens/load/p/scr/ParusCopier.scr            | Loading screen       | Screen dump        |
+-------------+----------+-----------------------------+-------------------------------------------------------------+----------------------+--------------------+

*/

'use strict';

const mariadb_username = 'root';
const mariadb_password = 'zxdb1234';
const mariadb_dbname = 'zxdb';

const mysql = require('mysql');
const https = require('https');
const HttpsAgent = require('agentkeepalive').HttpsAgent;

const keepaliveAgent = new HttpsAgent({
    keepAlive: true,
});

var downloads = [];

var getAllDownloads = function(mirrorHost, mirrorPrefix) {
    let start = Date.now();

    var mysql = require('mysql');
    var connection = mysql.createConnection({
        host: 'localhost',
        user: mariadb_username,
        password: mariadb_password,
        database: mariadb_dbname
    });

    connection.connect();

    console.log('get all downloads');
    var done = false;
    var filesCounter = 0;
    connection.query('SELECT d.id as download_id, e.id as entry_id, e.title as title, d.file_link as file_link, ft.text as filetype, ftt.text as formattype FROM downloads d INNER JOIN entries e ON e.id = d.entry_id LEFT JOIN filetypes ft on ft.id = d.filetype_id LEFT JOIN formattypes ftt on ftt.id = d.formattype_id WHERE d.file_link IS NOT NULL ORDER BY title ASC, filetype, formattype', function(error, results, fields) {
        if (error) {
            throw new Error("Can't connect: ", error.stack);
        }

        var i = 0;
        for (; i < results.length; i++) {
            var item = {
                download_id: results[i].download_id,
                entry_id: results[i].entry_id,
                title: results[i].title,
                filetype: results[i].filetype,
                formattype: results[i].formattype,
                file_link: results[i].file_link
            };
            downloads.push(item);
            filesCounter++;
        }
        done = true;
    });
    require('deasync').loopWhile(function() {
        return !done;
    });
    connection.destroy();
    console.log('total downloads %d - %d ms', downloads.length, Date.now() - start);
}

var checkFileHEAD = function(idx, host, path) {
    console.log('checking: %d - %s', idx, path);
    const options = {
        host: host,
        port: 443,
        path: path,
        method: 'HEAD',
        agent: keepaliveAgent,
        maxSockets: 10,
        headers: { "Connection": "keep-alive" }
    };

    let start = Date.now();
    var httpStatus;
    const req = https.request(options, res => {
        console.log(idx + '=> %d, %d ms %s', res.statusCode, Date.now() - start, options.path);
        if(res.statusCode !== 200) {
            console.error(downloads[idx].download_id + '\t' + downloads[idx].entry_id + '\t' + downloads[idx].title + '\t' + downloads[idx].filetype + '\t' + downloads[idx].formattype + '\t' + downloads[idx].file_link);
        }
        httpStatus = res.statusCode;
    });
    req.on('error', e => {
        console.log('problem with request: ' + e.message);
    });
    req.end();
    require('deasync').loopWhile(function() {
        return !httpStatus;
    });

}

getAllDownloads('archive.zx-spectrum.org.uk', '/WoS');

console.error('download_id\tentry_id\ttitle\tfiletype\tformattype\tfile_link');
var j = 0;
for (; j < downloads.length ; j++) {
    var file_link = '/WoS' + downloads[j].file_link;
    file_link = file_link.replace(/ /g, "%20");

    checkFileHEAD(j, 'archive.zx-spectrum.org.uk', file_link);
};
