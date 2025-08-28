import pandas as pd

from mage_ai.settings.repo import get_repo_path
from mage_ai.io.bigquery import BigQuery
from mage_ai.io.config import ConfigFileLoader
from pandas import DataFrame
from os import path

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def export_data_to_big_query(source, **kwargs) -> None:
    """
    'data_dict' is a dictionary with the name of the tables as keys and the tables as values.
    

    Docs: https://docs.mage.ai/design/data-loading#bigquery
    """
    table_id = 'my-first-project.moonlit-grail-469521-n4.Bronze_Layer_DW'
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = 'default'

    project_id = "my-first-project"
    dataset = "Bronze_Layer_DW"

    bq = BigQuery.with_config(ConfigFileLoader(config_path, config_profile))

    for table_name, table in source.items():
        table_id = f"{dataset}.{table_name}"  # Only dataset.table
        bq.export(
            table,
            table_id,
            if_exists='replace',  # or 'append'
        )
    