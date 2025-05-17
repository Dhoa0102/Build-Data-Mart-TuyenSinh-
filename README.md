# Build-Data-Mart-TuyenSinh-
MÔ TẢ HỆ THỐNG

Cho Cơ sở dữ liệu gồm 3 bảng ThiSinh, NguyenVong, XetTuyen

ThiSinh chứa thông tin điểm thi của thí sinh.

NguyenVong chứa nguyện vọng của thí sinh sắp xếp theo thứ tự ưu tiên.

XetTuyen: Chứa cấu trúc thông tin xét tuyển của một trường đại học.

Bộ Giáo dục và Đào tạo tổ chức xét tuyển đại học theo quy chế: thí sinh được đăng ký nhiều nguyện vọng vào các ngành, chương trình đào tạo của nhiều trường đại học. Các trường đại học có trách nhiệm xét tuyển theo tổ hợp môn, phương thức tuyển sinh và điểm chuẩn do trường xác định. Quy trình xét tuyển được chia thành nhiều chu kỳ. Sau mỗi chu kỳ, Bộ GDĐT thực hiện xử lý nguyện vọng để đảm bảo mỗi thí sinh chỉ trúng tuyển một nguyện vọng cao nhất.Ở mỗi chu kỳ, Trường đại học quyết định điểm chuẩn cho mỗi ngành của trường để xác định danh sách thí sinh trúng tuyển dự kiến để gửi lên hệ thống của Bộ (Bộ GDĐT thực hiện xử lý nguyện vọng để đảm bảo mỗi thí sinh chỉ trúng tuyển một nguyện vọng cao nhất).

Nguyên tắc xét tuyển của Trường

Điểm trúng tuyển được xác định để số lượng tuyển được theo từng ngành, chương trình đào tạo phù hợp với số lượng chỉ tiêu đã công bố.

Đối với một ngành đào tạo theo một phương thức và tổ hợp môn, tất cả thí sinh được xét chọn bình đẳng theo điểm xét không phân biệt thứ tự ưu tiên của nguyện vọng đăng ký, Trường hợp nhiều thí sinh có cùng điểm xét ở cuối danh sách, cơ sở đào tạo có thể sử dụng tiêu chí phụ là thứ tự nguyện vọng (để xét chọn những thí sinh có thứ tự nguyện vọng cao hơn);

Sau mỗi chu kỳ xét tuyển, cơ sở đào tạo tải lên hệ thống của bộ danh sách thí sinh dự kiến đủ điều kiện trúng tuyển các ngành. Hệ thống xử lý nguyện vọng sẽ tự động loại bỏ khỏi danh sách những nguyện vọng thấp của thí sinh đủ điều kiện trúng tuyển nhiều nguyện vọng, trả lại danh sách thí sinh dự kiến trúng tuyển theo nguyện vọng cao nhất.

Căn cứ kết quả xử lý nguyện vọng, cơ sở đào tạo lặp lại quy trình xét tuyển ở chu kỳ sau, điều chỉnh điểm trúng tuyển cho phù hợp với chỉ tiêu trong thời hạn quy định. Ở chu kỳ cuối, cơ sở đào tạo quyết định điểm trúng tuyển vào các ngành, chương trình đào tạo (theo các phương thức tuyển sinh) và tải lên hệ thống danh sách (chính thức) thí sinh đủ điều kiện trúng tuyển. Trên cơ sở kết quả xử lý nguyện vọng cuối cùng, cơ sở đào tạo quyết định danh sách thí sinh trúng tuyển vào các ngành, chương trình đào tạo.

MỘT SỐ YÊU CẦU GIÚP XÁC ĐỊNH DIM VÀ FACT CỦA DWH CỦA TRƯỜNG ĐẠI HỌC

1.	Theo dõi kết quả xét tuyển trong từng chu kỳ
   
•	Bao nhiêu thí sinh được xét tuyển theo từng ngành / tổ hợp

•	Điểm chuẩn là bao nhiêu ở mỗi chu kỳ xét

•	Tỷ lệ chọi (số NV đăng ký / chỉ tiêu) theo ngành

2. Phân tích phân bố điểm xét tuyển của thí sinh
   
•	Điểm xét tuyển cao nhất, thấp nhất, trung bình theo ngành.

•	Số lượng thí sinh đồng điểm tại điểm chuẩn.

•	Phân tích tỷ lệ trúng tuyển theo từng mức điểm.

3. Kiểm soát chỉ tiêu tuyển sinh
   
•	Tổng số thí sinh trúng tuyển so với chỉ tiêu công bố từng ngành.

•	Ngành nào vượt chỉ tiêu/không đủ chỉ tiêu

MỘT SỐ YÊU CẦU GIÚP XÁC ĐỊNH DIM VÀ FACT CỦA DWH CỦA BỘ

•	Trường/ngành nào vượt chỉ tiêu

•	Tổng chỉ tiêu, số lượng trúng tuyển, và tỷ lệ thực tuyển 


