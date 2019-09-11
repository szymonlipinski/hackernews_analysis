#!/usr/bin/env python

import csv
import re

import click


def get_type(data: list) -> str:
    """
    Tries to find a proper type for the passed values.
    It uses a couple of regular expressions, like the ints should have only numbers,
    floats have numbers with one dot.
    
    If they don't fit, then the default type is TEXT.
    """
    if all([re.match(r"^\s*\d*\s*$", n) for n in data]):
        return "INT"
    if all([re.match(r"^\s*\d*(\.\d*)?\s*$", n) for n in data]):
        return "FLOAT"
    return "TEXT"


def build_create_sql(table_name: str, names: list, types: list) -> str:

    cols = ",\n".join([f"    {name} {type}" for name, type in zip(names, types)])

    return f"""
CREATE TABLE {table_name} (
{cols}
);
"""


def build_indices_sql(table_name: str, names: list) -> str:
    return "\n".join([
        f"CREATE INDEX i_{table_name}_{name} ON {table_name} ({name});"
        for name
        in names])


def save_sql_file(file_name: str, table_name: str, sql: str, desc: str) -> None:
    with open(file_name, "w") as f:
        f.write(sql)
        click.secho(f"Created file {file_name} containing {desc}", fg='red')


@click.command()
@click.option("-f", "--csv-file-name", help="csv file name to check")
@click.option("-n", "--lines-number", default=3, type=int, help="number of csv files to check")
@click.option("-t", "--table-name", required=True, help="table name to generate the files for")
def run(csv_file_name, lines_number, table_name):
    click.secho(f"Reading {lines_number} linues from \"{csv_file_name}\".", fg='green')
    lines = []
    with open(csv_file_name) as f:
        reader = csv.reader(f)
        for index, row in enumerate(reader):
            if index >= lines_number:
                break
            lines += [row]
    names = lines[0]
    types = []
    click.secho(f"Found {len(names)} columns in the csv file", fg='green')

    click.secho(f"\nThe types are:", fg='yellow')
    click.secho(f"-" * 80, fg='blue')
    for n in range(len(names)):
        type = get_type([x[n] for x in lines[1:]])
        types += [type]
        click.secho(f"{names[n]} ", fg="yellow", nl=False)
        click.secho(f"{type}", fg='red')
    click.secho(f"-" * 80, fg='blue')

    create_fname = f"{table_name}.create.sql"
    create_sql = build_create_sql(table_name, names, types)
    save_sql_file(create_fname, table_name, create_sql, "sql for creating the table.")

    index_fname = f"{table_name}.normal.indices.sql"
    index_sql = build_indices_sql(table_name, names)
    save_sql_file(index_fname, table_name, index_sql, "sql for creating indices for all the columns.")


if __name__ == '__main__':
    run()
