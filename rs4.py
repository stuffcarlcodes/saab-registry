#!/usr/bin/env python

from contextlib import closing
from flask import Flask
from flask import abort, g, make_response, render_template
import pandas as pd
import sqlite3
import sys

DATABASE = 'registry.sqlite'
DEBUG = True

app = Flask(__name__)
app.config.from_object(__name__)


def db():
    database = getattr(g, 'db', None)
    if database is None:
        database = g.db = sqlite3.connect(app.config['DATABASE'])
        database.row_factory = sqlite3.Row
    return database


def query_db(query, args=(), one=False):
    with closing(db().execute(query, args)) as cursor:
        result = cursor.fetchall()
        return (result[0] if result else None) if one else result


@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, 'db', None)
    if db is not None:
        db.close()


@app.route('/')
def index():
    cars = query_db("""
    select
        registry.vin,
        registry.model_year,

        registry.paint_code,
        paint_codes.paint_color,
        paint_codes.exclusive as exclusive_paint,

        registry.interior_code,
        interior_codes.interior_color,
        interior_codes.exclusive as exclusive_interior,

        registry.trim_code,
        trim_codes.trim,
        trim_codes.exclusive as exclusive_trim,

        body_styles.body_style_id,
        body_styles.body_style
    from
        registry,
        paint_codes,
        interior_codes,
        trim_codes,
        body_styles
    where
        registry.paint_code == paint_codes.paint_code
        and registry.interior_code == interior_codes.interior_code
        and registry.trim_code == trim_codes.trim_code
        and registry.body_style == body_styles.body_style_id
    """)
    return render_template('index.html', cars=cars)

@app.route('/car')
@app.route('/car/<vin>')
def car(vin):
    car = query_db("""
    select
        registry.vin,
        registry.model_year,

        registry.paint_code,
        paint_codes.paint_color,
        paint_codes.exclusive as exclusive_paint,

        registry.interior_code,
        interior_codes.interior_color,
        interior_codes.exclusive as exclusive_interior,

        registry.trim_code,
        trim_codes.trim,
        trim_codes.exclusive as exclusive_trim,

        body_styles.body_style_id,
        body_styles.body_style,

        registry.location,
        registry.notes,
        registry.owner
    from
        registry,
        paint_codes,
        interior_codes,
        trim_codes,
        body_styles
    where
        vin = ?
        and registry.paint_code == paint_codes.paint_code
        and registry.interior_code == interior_codes.interior_code
        and registry.trim_code == trim_codes.trim_code
        and registry.body_style == body_styles.body_style_id
    """, (vin,), one=True)
    if not car:
        abort(404)

    packages = query_db("""
    select
        packages.package,
        packages.description
    from
        packages,
        car_packages
    where
        car_packages.vin = ?
        and packages.package = car_packages.package
    """, (vin,));
    return render_template('car.html', car=car, packages=packages)


if __name__ == '__main__':
    app.run()
