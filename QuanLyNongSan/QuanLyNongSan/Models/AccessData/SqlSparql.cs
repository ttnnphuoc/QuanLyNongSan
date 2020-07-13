using Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace QuanLyNongSan.Models.AccessData
{
    public class SqlSparql
    {
        public int ID { get; set; }
        public string NameTable { get; set; }
        public string Name { get; set; }
        public string SqlString { get; set; }
        public List<SqlSparql> getAllSQL(string id = "")
        {
            return CBO.FillCollection<SqlSparql>(DataProvider.Instance.ExecuteReader("GetAllSQLSparql", id));
        }
    }
}