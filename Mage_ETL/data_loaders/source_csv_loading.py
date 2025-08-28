import os
import pandas as pd

from mage_ai.io.file import FileIO
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_file(*args, **kwargs):
    """
    All csv files from the source is extracted in this block.
    The extracted files are organized as a dict. 

    For multiple directories, use the following:
        FileIO().load(file_directories=['dir_1', 'dir_2'])

    Docs: https://docs.mage.ai/design/data-loading#fileio
    """
    """
    Load each CSV into a DataFrame and store it in a dict with a friendly key.
    """
    # Load each CSV
    cust_info_df = pd.read_csv(
        '/Users/joeraymond/Desktop/Data_Science_Projects/Data_Warehousing_Project/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
    )
    prd_info_df = pd.read_csv(
        '/Users/joeraymond/Desktop/Data_Science_Projects/Data_Warehousing_Project/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
    )
    sales_details_df = pd.read_csv(
        '/Users/joeraymond/Desktop/Data_Science_Projects/Data_Warehousing_Project/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
    )
    cust_erp_df = pd.read_csv(
        '/Users/joeraymond/Desktop/Data_Science_Projects/Data_Warehousing_Project/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
    )
    loc_erp_df = pd.read_csv(
        '/Users/joeraymond/Desktop/Data_Science_Projects/Data_Warehousing_Project/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
    )
    px_cat_df = pd.read_csv(
        '/Users/joeraymond/Desktop/Data_Science_Projects/Data_Warehousing_Project/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
    )

    # Create dict with friendly keys
    source = {
        'crm_cust_info': cust_info_df,
        'crm_prd_info': prd_info_df,
        'crm_sales_details': sales_details_df,
        'erp_cust': cust_erp_df,
        'erp_loc': loc_erp_df,
        'erp_px_cat': px_cat_df,
    }

    return source 
     

    @test
    def test_output(output, *args) -> None:
        """
        Template code for testing the output of the block.
        """
        assert output is not None, 'The output is undefined'
