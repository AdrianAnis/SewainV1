package model;

public abstract class Property implements Reportable {

    protected int propertyId;
    protected String name;
    protected String location;
    protected double price;
    protected String propertyType;
    protected boolean availability;
    protected String verificationStatus;
    protected String flagStatus;
    protected String flagReason;
    protected String photos;
    protected String description;
    protected String facilities;
    protected String ownerName;
    protected String ownerProfilePic;
    protected int ownerId;

    public Property() {
    }

    public Property(int propertyId, String name, String location, double price, String propertyType,
            boolean availability, String verificationStatus, String flagStatus, String photos,
            String description, String facilities) {
        this.propertyId = propertyId;
        this.name = name;
        this.location = location;
        this.price = price;
        this.propertyType = propertyType;
        this.availability = availability;
        this.verificationStatus = verificationStatus;
        this.flagStatus = flagStatus;
        this.photos = photos;
        this.description = description;
        this.facilities = facilities;
    }

    public int getPropertyId() {
        return propertyId;
    }

    public void setPropertyId(int propertyId) {
        this.propertyId = propertyId;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getPropertyType() {
        return propertyType;
    }

    public void setPropertyType(String propertyType) {
        this.propertyType = propertyType;
    }

    public boolean isAvailability() {
        return availability;
    }

    public void setAvailability(boolean availability) {
        this.availability = availability;
    }

    public String getVerificationStatus() {
        return verificationStatus;
    }

    public void setVerificationStatus(String verificationStatus) {
        this.verificationStatus = verificationStatus;
    }

    public String getFlagStatus() {
        return flagStatus;
    }

    public void setFlagStatus(String flagStatus) {
        this.flagStatus = flagStatus;
    }

    public String getFlagReason() {
        return flagReason;
    }

    public void setFlagReason(String flagReason) {
        this.flagReason = flagReason;
    }

    public String getPhotos() {
        return photos;
    }

    public void setPhotos(String photos) {
        this.photos = photos;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getFacilities() {
        return facilities;
    }

    public void setFacilities(String facilities) {
        this.facilities = facilities;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    public String getOwnerProfilePic() {
        return ownerProfilePic;
    }

    public void setOwnerProfilePic(String ownerProfilePic) {
        this.ownerProfilePic = ownerProfilePic;
    }

    public void getDetail() {
        System.out.println("Nama Property : " + name);
        System.out.println("Lokasi : " + location);
        System.out.println("Harga : " + price);
    }

    public void updateStatus() {
        System.out.println("Status property diperbarui");
    }

    @Override
    public void report() {
        System.out.println("Property dilaporkan");
    }

    @Override
    public String getReportStatus() {
        return "Pending";
    }

    @Override
    public void createReport(Report report) {
        System.out.println("Membuat laporan pelanggaran untuk properti ID: " + propertyId);
    }

    public String getGender() {
        return "";
    }

    public String getRoomType() {
        return "";
    }

    public int getJumlahKamar() {
        return 0;
    }

    public double getLuasTanah() {
        return 0.0;
    }

    public int getDurasiMinimum() {
        return 0;
    }

    public int getLantai() {
        return 0;
    }

    public String getNomorUnit() {
        return "";
    }

    public String getTipeUnit() {
        return "";
    }

    public abstract java.util.List<String> getSpecificDetails();

    public abstract String toJson();

    public String escapeJson(String s) {
        if (s == null)
            return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    protected String buildBaseJson() {
        StringBuilder sb = new StringBuilder();
        sb.append("\"propertyId\":").append(propertyId).append(",");
        sb.append("\"id\":\"").append(propertyId).append("\",");
        sb.append("\"name\":\"").append(escapeJson(name)).append("\",");
        sb.append("\"location\":\"").append(escapeJson(location)).append("\",");
        sb.append("\"price\":").append(price).append(",");
        sb.append("\"propertyType\":\"").append(escapeJson(propertyType)).append("\",");
        sb.append("\"type\":\"").append(escapeJson(propertyType)).append("\",");
        sb.append("\"availability\":").append(availability ? 1 : 0).append(",");
        sb.append("\"verificationStatus\":\"").append(escapeJson(verificationStatus)).append("\",");
        sb.append("\"photos\":\"").append(escapeJson(photos)).append("\",");
        sb.append("\"image\":\"").append(escapeJson(photos)).append("\",");
        sb.append("\"rawPhotos\":\"").append(escapeJson(photos)).append("\",");
        sb.append("\"description\":\"").append(escapeJson(description)).append("\",");
        sb.append("\"ownerName\":\"").append(escapeJson(ownerName)).append("\",");
        sb.append("\"ownerProfilePic\":\"").append(escapeJson(ownerProfilePic)).append("\",");
        sb.append("\"facilities\":[");
        if (facilities != null && !facilities.trim().isEmpty()) {
            String[] facs = facilities.split(",");
            for (int k = 0; k < facs.length; k++) {
                sb.append("\"").append(escapeJson(facs[k].trim())).append("\"");
                if (k < facs.length - 1)
                    sb.append(",");
            }
        }
        sb.append("],");
        double pPrice = price;
        String priceLabel = "";
        if (pPrice >= 1000000) {
            double priceJt = pPrice / 1000000.0;
            if (priceJt == (long) priceJt) {
                priceLabel = "Rp " + (long) priceJt + " jt/bln";
            } else {
                priceLabel = "Rp " + priceJt + " jt/bln";
            }
        } else {
            priceLabel = "Rp " + (long) pPrice + "/bln";
        }
        sb.append("\"priceLabel\":\"").append(escapeJson(priceLabel)).append("\"");
        return sb.toString();
    }
}
