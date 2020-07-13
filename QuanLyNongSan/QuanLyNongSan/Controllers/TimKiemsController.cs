using Core;
using Newtonsoft.Json;
using QuanLyNongSan.Models;
using QuanLyNongSan.Models.AccessData;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Xml.Serialization;
using VDS.RDF;
using VDS.RDF.Query;
using VDS.RDF.Writing.Formatting;

namespace QuanLyNongSan.Controllers
{
    public class TimKiemsController : Controller
    {
        private QLCUNGUNGEntities db = new QLCUNGUNGEntities();
        private SqlSparql sqlSparql = new SqlSparql();
        // GET: TimKiems
        public ActionResult Index(string ValueSearch, string option, string dhx = "")
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }

            if (string.IsNullOrEmpty(ValueSearch)) return View();         

            ViewBag.NhanVien = db.NHANVIENs.Where(x => x.isXoa == false).ToList();
            ViewBag.ListNCC = db.NHACUNGCAPs.Where(x => x.isXoa == false).ToList();
            switch (option)
            {
                case "product":
                    ViewBag.Type = 1;
                    ViewBag.ListLSP = db.LOAISANPHAMs.Where(x => x.isXoa == false).ToList();
                    ViewBag.LisData = CBO.FillCollection<SANPHAM>(DataProvider.Instance.ExecuteReader("sp_FindStringInTable", ValueSearch, "dbo", "SanPham"));
                    break;
                case "category":
                    ViewBag.Type = 2;
                    ViewBag.LisData = CBO.FillCollection<LOAISANPHAM>(DataProvider.Instance.ExecuteReader("sp_FindStringInTable", ValueSearch, "dbo", "LOAISANPHAM"));
                    break;
                case "input":
                    if(dhx.Equals("2"))
                    {
                        ViewBag.LisData = db.DONHANGNHAPs.Where(x => x.MaNhaCC + "" == ValueSearch).ToList();
                    } else
                    {
                        ViewBag.LisData = CBO.FillCollection<DONHANGNHAP>(DataProvider.Instance.ExecuteReader("sp_FindStringInTable", ValueSearch, "dbo", "DONHANGNHAP"));
                    }
                    ViewBag.Type = 3;
                    ViewBag.ListNCC = db.NHACUNGCAPs.Where(x => x.isXoa == false).ToList();
                    break;
                case "output":
                    ViewBag.Type = 4;
                    if (dhx.Equals("1"))
                    {
                        ViewBag.LisData = db.DONHANGXUATs.Where(x => x.MaDaiLy + "" == ValueSearch).ToList();
                    } else if (dhx.Equals("3"))
                    {
                        string sql = string.Format(@"select dhx.* from DONHANGXUAT dhx
                                    left join LUUVET lv on lv.MaDHX = dhx.MaDHX
                                    left join TRAM t on t.MaTram = lv.MaTram
                                    where t.MaTram = '{0}'",ValueSearch);
                        ViewBag.LisData = db.Database.SqlQuery<DONHANGXUAT>(sql).ToList();
                    } else
                    {
                        ViewBag.LisData = CBO.FillCollection<DONHANGXUAT>(DataProvider.Instance.ExecuteReader("sp_FindStringInTable", ValueSearch, "dbo", "DONHANGXUAT"));
                    }
                    
                    break;
                case "luuvet":
                    ViewBag.Type = 5;
                    ViewBag.Tram = db.TRAMs.Where(x => x.isXoa == false).ToList(); ;
                    ViewBag.LisData = CBO.FillCollection<LUUVET>(DataProvider.Instance.ExecuteReader("sp_FindStringInTable", ValueSearch, "dbo", "LUUVET"));
                    break;
                case "NCC":
                    ViewBag.Type = 6;
                    ViewBag.Tram = db.TRAMs.Where(x => x.isXoa == false).ToList(); ;
                    ViewBag.LisData = CBO.FillCollection<NHACUNGCAP>(DataProvider.Instance.ExecuteReader("sp_FindStringInTable", ValueSearch, "dbo", "NHACUNGCAP"));
                    break;
                case "nhanvien":
                    ViewBag.Type = 7;
                    //ViewBag.Tram = db.TRAMs.Where(x => x.isXoa == false).ToList(); ;
                    ViewBag.LisData = CBO.FillCollection<NHANVIEN>(DataProvider.Instance.ExecuteReader("sp_FindStringInTable", ValueSearch, "dbo", "NHANVIEN"));
                    break;
                case "goiy":
                    int idx = ValueSearch.IndexOf('(');
                    if (idx >= 0)
                    {
                        

                        int idxLast = ValueSearch.IndexOf(')');
                        int idxFirst = ValueSearch.IndexOf('(');
                        int? idSql = int.Parse(ValueSearch.Substring(ValueSearch.IndexOf('(')+ 1, (idxLast - idxFirst)-1));
                        string tagName = ValueSearch.Substring(ValueSearch.IndexOf('_')+1);

                        SQLGOIY sQLGOIY = db.SQLGOIYs.Find(idSql);
                        ViewBag.SQLString = sQLGOIY.Name;

                        switch (tagName)
                        {
                            case "SP":
                                ViewBag.Type = 1;
                                ViewBag.ListLSP = db.LOAISANPHAMs.Where(x => x.isXoa == false).ToList();
                                ViewBag.LisData = db.Database.SqlQuery<SANPHAM>(sQLGOIY.SqlString).ToList();
                                break;
                            case "NV":
                                ViewBag.Type = 7;
                                ViewBag.LisData = db.Database.SqlQuery<NHANVIEN>(sQLGOIY.SqlString).ToList();
                                break;
                            case "DHX":
                                ViewBag.Type = 4;
                                ViewBag.ShowSoLuong = 1;
                                ViewBag.LisData = db.Database.SqlQuery<SearchDonHangXuat>(sQLGOIY.SqlString).ToList();
                                break;
                            case "DHN":
                                if (sQLGOIY.ID == 63)
                                {
                                    ViewBag.Type = 10;
                                    ViewBag.ListNCC = db.NHACUNGCAPs.Where(x => x.isXoa == false).ToList();
                                    ViewBag.LisData = db.Database.SqlQuery<SearchTinhTongDaiLy>(sQLGOIY.SqlString).ToList();
                                } else
                                {
                                    ViewBag.Type = 12;
                                    ViewBag.LisData = db.Database.SqlQuery<DetailSearchs>(sQLGOIY.SqlString).ToList();
                                }
                                break;
                            case "DL":
                                if (sQLGOIY.ID == 62)
                                {
                                    ViewBag.Type = 9;
                                    ViewBag.LisData = db.Database.SqlQuery<SearchTinhTongDaiLy>(sQLGOIY.SqlString).ToList();
                                }
                                else
                                {
                                    ViewBag.Type = 8;
                                    ViewBag.LisData = db.Database.SqlQuery<SearchDaiLy>(sQLGOIY.SqlString).ToList();
                                }
                                break;
                            case "LV":
                                ViewBag.Type = 11;
                                ViewBag.LisData = db.Database.SqlQuery<SearchTinhTongDaiLy>(sQLGOIY.SqlString).ToList();
                                break;
                        }
                    }

                    break;
            }
            return View();
        }
        public JsonResult LoadDataInit(string ValueSearch, string option)
        {
            List<string> All = new List<string>();
            List<string> sp = db.SANPHAMs.Where(x => x.isXoa == false).Select(x => x.TenSP).ToList();
            List<string> ncc = db.NHACUNGCAPs.Where(x => x.isXoa == false).Select(x => x.TenNhaCC).ToList();
            List<string> lsp = db.LOAISANPHAMs.Where(x => x.isXoa == false).Select(x => x.TenLoai).ToList();
            List<string> nv = db.NHANVIENs.Where(x => x.isXoa == false).Select(x => x.Hoten).ToList();
            List<string> dhx = db.DONHANGXUATs.Where(x => x.isXoa == false).Select(x => x.MaDHX+"").ToList();
            List<string> dhn = db.DONHANGNHAPs.Where(x => x.isXoa == false).Select(x => x.MaDHN +"").ToList();
            List<string> sqlGoiY = db.SQLGOIYs.Select(x => x.Name).ToList();

            All.AddRange(sp);
            All.AddRange(ncc);
            All.AddRange(lsp);
            All.AddRange(nv);
            All.AddRange(dhn);
            All.AddRange(dhx);
            All.AddRange(sqlGoiY);

            return Json(new { data = JsonConvert.SerializeObject(All.Distinct()), dataSQL = JsonConvert.SerializeObject(sqlSparql.getAllSQL().Select(x=>x.Name).ToList()) }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetDataSearch(string str)
        {
            List<SearchAll> data = new List<SearchAll>();
            if (string.IsNullOrEmpty(str))
            {
                return Json(new { data = JsonConvert.SerializeObject(data) }, JsonRequestBehavior.AllowGet);
            }

            data = CBO.FillCollection<SearchAll>(DataProvider.Instance.ExecuteReader("SearchAllTables", str));
            return Json(new { data = JsonConvert.SerializeObject(data) },JsonRequestBehavior.AllowGet);
        }
        public ActionResult ReadFileOwl(string ValueSearchSparql)
        {
            if (string.IsNullOrEmpty(ValueSearchSparql)) return View();

            IGraph g = new Graph();
            var path = Path.Combine(Server.MapPath("~/App_Data/uploads/Quanlycungung.owl"));
            List<LOAISANPHAM> loaiSPDataList = new List<LOAISANPHAM>();

            if (!System.IO.File.Exists(path))
            {
                ViewBag.Data = loaiSPDataList;
                ViewBag.MessageError = "File owl không tồn tại. Vui lòng kiểm tra lại";
                return View();
            }
            g.LoadFromFile(path);

            try
            {
                int idxLast = ValueSearchSparql.IndexOf(')');
                int idxFirst = ValueSearchSparql.IndexOf('(');
                int? idSql = int.Parse(ValueSearchSparql.Substring(ValueSearchSparql.IndexOf('(') + 1, (idxLast - idxFirst) - 1));
                SqlSparql data = CBO.FillObject<SqlSparql>(DataProvider.Instance.ExecuteReader("GetAllSQLSparql", idSql));
                ViewBag.SQLString = data.Name;
                string sql = @"PREFIX Root: <http://www.semanticweb.org/ngocbao/ontologies/2019/11/untitled-ontology-25#> "+ data.SqlString;
                SparqlResultSet results = g.ExecuteQuery(sql) as SparqlResultSet;
                if (results is SparqlResultSet)
                {
                    foreach (SparqlResult result in results)
                    {
                        List<VDS.RDF.INode> a = result.Select(x => x.Value).ToList();
                        loaiSPDataList.Add(ConvertDataLoaiSP(a));
                    }
                }
   
            }
            catch (RdfQueryException queryEx)
            {
                //There was an error executing the query so handle it here
                Console.WriteLine(queryEx.Message);
            }
            ViewBag.Data = loaiSPDataList;
            return View();
        }

        private LOAISANPHAM ConvertDataLoaiSP(List<VDS.RDF.INode> data)
        {
            string id = (data[0]+"").Split('^')[0];
            string name = (data[1] + "").Split('^')[0];
            LOAISANPHAM a = new LOAISANPHAM();
            a.MaLoai =  int.Parse(id);
            a.TenLoai = name;
            return a;
        }
        public ActionResult Details(string id)
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            if (string.IsNullOrEmpty(id))
            {
                return HttpNotFound();
            }

            string[] str = id.Split('_');
            ViewBag.DHN = 0;
            List<DetailSearchs> productList = new List<DetailSearchs>();
            switch (str[0])
            {
                case "NV":
                    productList = CBO.FillCollection<DetailSearchs>(DataProvider.Instance.ExecuteReader("sp_FindNhanVien", str[1]));
                    break;

                case "SP":
                    productList = CBO.FillCollection<DetailSearchs>(DataProvider.Instance.ExecuteReader("sp_FindSanPham", str[1]));
                    break;
                case "NCC":
                    ViewBag.DHN = 1;
                    productList = CBO.FillCollection<DetailSearchs>(DataProvider.Instance.ExecuteReader("sp_FindNhaCC", str[1]));
                    break;
                case "LSP":
                    productList = CBO.FillCollection<DetailSearchs>(DataProvider.Instance.ExecuteReader("sp_FindLoaiSanPham", str[1]));
                    break;
                case "DHN":
                    ViewBag.DHN = 1;
                    productList = CBO.FillCollection<DetailSearchs>(DataProvider.Instance.ExecuteReader("sp_FindDonHangNhap", str[1]));
                    break;
                case "DHX":
                    productList = CBO.FillCollection<DetailSearchs>(DataProvider.Instance.ExecuteReader("sp_FindDonHangXuat", str[1]));
                    break;
            }
            ViewBag.ListDetail = productList;
            return View();
        }

        public ActionResult UploadFiles()
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            return View();
        }

        [HttpPost]
        public ActionResult UploadFiles(HttpPostedFileBase fileUp)
        {
            try
            {
                if (fileUp.ContentLength > 0)
                {
                    DeleteFiles();
                    var fileName = Path.GetFileName("Quanlycungung.owl");
                    var path = Path.Combine(Server.MapPath("~/App_Data/uploads"), fileName);
                    fileUp.SaveAs(path);
                    ViewBag.Message = "Upload thành công";
                }
                return View();

            } catch(Exception ex)
            {
                ViewBag.Message = "Upload thất bại";
                return View();
            }
           
        }
        public ActionResult DeleteFiles()
        {
            var path = Server.MapPath("~/App_Data/uploads");

            string[] files = Directory.GetFiles(path);
            foreach (string file in files)
            {
                System.IO.File.Delete(file);
            }
            return View();
        }

        public ActionResult TonKho()
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            List<HangTonKho> hangTonKhoDataList = CBO.FillCollection<HangTonKho>(DataProvider.Instance.ExecuteReader("HangTonKho"));
            return View(hangTonKhoDataList);
        }

        public ActionResult DetailsTonKho(string id)
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            if (string.IsNullOrEmpty(id))
            {
                return HttpNotFound();
            }

            string[] strParam = id.Split('_');
            List<DetailSearchs> productList = new List<DetailSearchs>();

            switch (strParam[0])
            {
                case "DHN":
                    ViewBag.TT = "Tồn Kho Đơn Hàng Nhập";
                    productList = CBO.FillCollection<DetailSearchs>(DataProvider.Instance.ExecuteReader("sp_FindDonHangNhapTonKho", strParam[1]));
                    ViewBag.DHN = 1;
                    break;
                case "DHX":
                    ViewBag.TT = "Tồn Kho Đơn Hàng Xuất";
                    productList = CBO.FillCollection<DetailSearchs>(DataProvider.Instance.ExecuteReader("sp_FindDonHangXuatTonKho", strParam[1]));
                    break;
            }
            //List<CHITIETDONHANGXUAT>
            return View(productList);
        }
        protected T FromXml<T>(String xml)
        {
            T returnedXmlClass = default(T);

            try
            {
                using (TextReader reader = new StringReader(xml))
                {
                    try
                    {
                        returnedXmlClass =
                            (T)new XmlSerializer(typeof(T)).Deserialize(reader);
                    }
                    catch (InvalidOperationException)
                    {
                        // String passed is not XML, simply return defaultXmlClass
                    }
                }
            }
            catch (Exception ex)
            {
            }

            return returnedXmlClass;
        }
    }
    public class DetailSearchs
    {
        public string MaDHX { set; get; }
        public string Hoten { set; get; }
        public string TenDL { set; get; }
        public string TenNhaCC { set; get; }
        public string TenTram { set; get; }
        public bool TrangThai { set; get; }
        public string SoLuong { set; get; }
        public string TenSP { set; get; }
        public string TenLoai { set; get; }
        public int MaSP { set; get; }
        public int ThoiGian { set; get; }
        public string PhuongTien { set; get; }
        public int MaDHN { set; get; }

    }
    public class SearchDonHangXuat
    {
        public int MaDHX { get; set; }
        public int MaDaiLy { get; set; }
        public Nullable<int> MaNV { get; set; }

        public Nullable<bool> TrangThai { get; set; }

        public int SoLuong { get; set; }
        public int MucChietKhau { set; get; }
        public int ThoiGian { set; get; }
        public string PhuongTien { set; get; }
    }

    public class SearchDaiLy
    {
        public int MaDL { set; get; }
        public string Ten { set; get; }
        public string SoDT { set; get; }
        public string DiaChi { set; get; }
        public int MaLoai { set; get; }
        public int Cap { set; get; }
        public string MucChietKhau { set; get; }
    }
    public class SearchTinhTongDaiLy
    {
        public int SoLuong { set; get; }
        public string Ten { set; get; }
        public string Ma { set; get; }
    }
    public class HangTonKho
    {
        public string TenSP { set; get; }
        public int MaSP { set; get; }
        public int SLN { set; get; }
        public int SLX { set; get; }
        public int SoLuongConLai { set; get; }
    }
    public class SearchAll
    {
        public string ColumnName { set; get; }
        public string ColumnValue { set; get; }
    }
}
