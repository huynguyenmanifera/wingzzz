export enum Layout {
  SinglePage = "single_page",
  TwoPages = "two_pages",
}

export enum BookType {
  Regular = "regular",
  Narrated = "narrated",
  AudioOnly = "audio_only",
}

export default interface Book {
  layout: Layout;
  totalPages: number;
  epubFileURL: string;
  coverURL: string;
  type: BookType;
}
