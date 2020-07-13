using Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace QuanLyNongSan.Models.AccessData
{
    public class GhiLog
    {
        public int Id { set; get; }
        public string Action { set; get; }
        public string Username { set; get; }
        public DateTime TimeAction { set; get; }
        public string Content { set; get; }
        public string TableName { set; get; }
        public List<GhiLog> GetAllGhiLog(string id = "")
        {
            List<GhiLog> lisData = new List<GhiLog>();
            lisData = CBO.FillCollection<GhiLog>(DataProvider.Instance.ExecuteReader("GetAllGhiLog", id));
            return lisData;
        }
        public void AddNewGhiLog(string action, string username, string content, string tableName)
        {
            DataProvider.Instance.ExecuteNonQuery("AddNewGhiLog", action, username, DateTime.Now, content, tableName);
        }
    }

    
}